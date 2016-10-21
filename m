From: Laszlo Ersek <lersek@redhat.com>
Subject: [PATCH] hwrng: core - don't pass stack allocated buffer to rng->read()
Date: Fri, 21 Oct 2016 22:32:04 +0200
Message-ID: <20161021203204.12556-1-lersek@redhat.com>
Cc: stable@vger.kernel.org#Forv3.15+, Amit Shah <amit.shah@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kees Cook <keescook@chromium.org>,
        Matt Mackall <mpm@selenic.com>,
        "Richard W . M . Jones" <rjones@redhat.com>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laszlo Ersek <lersek@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The virtio-rng backend for hwrng passes the buffer that it receives for
filling to sg_set_buf() directly, in:

virtio_read()       [drivers/char/hw_random/virtio-rng.c]
  register_buffer() [drivers/char/hw_random/virtio-rng.c]
    sg_init_one()   [lib/scatterlist.c]
      sg_set_buf()  [include/linux/scatterlist.h]

In turn, the sg_set_buf() function, when built with CONFIG_DEBUG_SG,
actively enforces (justifiedly) that the buffer used within the
scatter-gather list live in physically contiguous memory:

  BUG_ON(!virt_addr_valid(buf));

The combination of the above two facts means that whatever calls
virtio_read() -- via the hwrng.read() method -- has to allocate the
recipient buffer in physically contiguous memory.

Although this ends up being a generic interface restriction that is not
documented at the abstract hwrng level ("include/linux/hw_random.h",
"Documentation/hw_random.txt"), the virtio-rng provider has not been
changed to implement bounce buffering. Instead, existing core commits have
accommodated the silent restriction, such as:

- f7f154f1246c hw_random: make buffer usable in scatterlist.

  which would allocate "rng_buffer" with kmalloc(), and

- be4000bc4644 hwrng: create filler thread

  which would allocate the new "rng_fillbuf" similarly.

One call site remains that breaks the silent restriction: the
add_early_randomness() function passes an on-stack array to hwrng.read(),
via rng_get_data(), resulting in the following (valid) BUG, when
CONFIG_DEBUG_SG is enabled:

> ------------[ cut here ]------------
> kernel BUG at ./include/linux/scatterlist.h:140!
> invalid opcode: 0000 [#1] SMP
> Modules linked in: virtio_pci(+) virtio_mmio virtio_input virtio_balloon
> virtio_scsi nd_pmem nd_btt virtio_net virtio_console virtio_rng
> virtio_blk virtio_ring virtio nfit crc32_generic crct10dif_pclmul
> crc32c_intel crc32_pclmul
> CPU: 0 PID: 1 Comm: init Not tainted 4.9.0-0.rc0.git6.2.fc26.x86_64 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-1.fc26
> 04/01/2014
> task: ffff91f29de53240 task.stack: ffffb820000cc000
> RIP: 0010:[<ffffffff8347e3fc>]  [<ffffffff8347e3fc>]
> sg_init_one+0x8c/0xa0
> RSP: 0018:ffffb820000cf7d0  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffffb820000cf858 RCX: 0000000000000028
> RDX: 0000262d800cf858 RSI: 0000000000000026 RDI: ffffb820800cf858
> RBP: ffffb820000cf7e8 R08: 000000000000006a R09: ffffb820000cf7f8
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000010
> R13: ffffb820000cf7f8 R14: 0000000000000010 R15: 0000000000000000
> FS:  00007fffd6e6e140(0000) GS:ffff91f29ee00000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fc67e24e000 CR3: 000000001bdad000 CR4: 00000000000406f0
> Stack:
>  ffff91f29be3b400 0000000000000001 ffffb820000cf858 ffffb820000cf848
>  ffffffffc0056226 0000000087654321 0000000000000002 0000000000000000
>  0000000000000000 0000000000000000 000000002a14e409 ffff91f29be3b400
> Call Trace:
>  [<ffffffffc0056226>] virtio_read+0xc6/0x110 [virtio_rng]
>  [<ffffffff835be9ee>] add_early_randomness+0x5e/0xd0
>  [<ffffffff835beaa5>] set_current_rng+0x45/0x160
>  [<ffffffff835bee47>] hwrng_register+0xf7/0x130
>  [<ffffffffc0056149>] virtrng_scan+0x19/0x30 [virtio_rng]
>  [<ffffffffc00467a8>] virtio_dev_probe+0x198/0x1e0 [virtio]
>  [<ffffffff835ebd53>] driver_probe_device+0x223/0x430
>  [<ffffffff835ec0dc>] __device_attach_driver+0x8c/0x100
>  [<ffffffff835ec050>] ? __driver_attach+0xf0/0xf0
>  [<ffffffff835e972a>] bus_for_each_drv+0x6a/0xb0
>  [<ffffffff835eb9c2>] __device_attach+0xe2/0x160
>  [<ffffffff835ec193>] device_initial_probe+0x13/0x20
>  [<ffffffff835eab93>] bus_probe_device+0xa3/0xb0
>  [<ffffffff835e85f2>] device_add+0x382/0x650
>  [<ffffffffc00929b0>] ? vp_modern_find_vqs+0x70/0x70 [virtio_pci]
>  [<ffffffffc00929b0>] ? vp_modern_find_vqs+0x70/0x70 [virtio_pci]
>  [<ffffffff835e88da>] device_register+0x1a/0x20
>  [<ffffffffc00463f9>] register_virtio_device+0xb9/0x100 [virtio]
>  [<ffffffffc0093673>] virtio_pci_probe+0xc3/0x140 [virtio_pci]
>  [<ffffffff834c97b5>] local_pci_probe+0x45/0xa0
>  [<ffffffff834ca81a>] ? pci_match_device+0xca/0x110
>  [<ffffffff834cac33>] pci_device_probe+0x103/0x150
>  [<ffffffff835ebd53>] driver_probe_device+0x223/0x430
>  [<ffffffff835ec043>] __driver_attach+0xe3/0xf0
>  [<ffffffff835ebf60>] ? driver_probe_device+0x430/0x430
>  [<ffffffff835e9653>] bus_for_each_dev+0x73/0xc0
>  [<ffffffff835eb47e>] driver_attach+0x1e/0x20
>  [<ffffffff835eaea3>] bus_add_driver+0x173/0x270
>  [<ffffffffc0099000>] ? 0xffffffffc0099000
>  [<ffffffff835ecca0>] driver_register+0x60/0xe0
>  [<ffffffffc0099000>] ? 0xffffffffc0099000
>  [<ffffffff834c90d0>] __pci_register_driver+0x60/0x70
>  [<ffffffffc009901e>] virtio_pci_driver_init+0x1e/0x1000 [virtio_pci]
>  [<ffffffff83002190>] do_one_initcall+0x50/0x180
>  [<ffffffff83130ac5>] ? rcu_read_lock_sched_held+0x45/0x80
>  [<ffffffff83275517>] ? kmem_cache_alloc_trace+0x277/0x2d0
>  [<ffffffff831fa457>] ? do_init_module+0x27/0x1f1
>  [<ffffffff831fa48f>] do_init_module+0x5f/0x1f1
>  [<ffffffff8315df91>] load_module+0x2401/0x2b40
>  [<ffffffff8315a7c0>] ? __symbol_put+0x70/0x70
>  [<ffffffff830ec480>] ? sched_clock_cpu+0x90/0xc0
>  [<ffffffff8323a9f3>] ? __might_fault+0x43/0xa0
>  [<ffffffff8315e86b>] SYSC_init_module+0x19b/0x1c0
>  [<ffffffff8315e9ae>] SyS_init_module+0xe/0x10
>  [<ffffffff83909941>] entry_SYSCALL_64_fastpath+0x1f/0xc2
> Code: ca 75 2c 49 8b 55 08 f6 c2 01 75 25 83 e2 03 81 e3 ff 0f 00 00 45
> 89 65 14 48 09 d0 41 89 5d 10 49 89 45 08 5b 41 5c 41 5d 5d c3 <0f> 0b
> 0f 0b 0f 0b 0f 0b 48 8b 15 05 ec 98 00 eb a3 0f 1f 00 55
> RIP  [<ffffffff8347e3fc>] sg_init_one+0x8c/0xa0
>  RSP <ffffb820000cf7d0>
> ---[ end trace 8120a17353b469c4 ]---

Prevent this by allocating a temporary buffer in add_early_randomness()
with kmalloc(). (The function add_early_randomness() should be called very
infrequently, therefore it makes sense to trade speed for storage; i.e.,
to allocate the buffer only temporarily, for every call separately.)

Cc: <stable@vger.kernel.org> # For v3.15+
Cc: Amit Shah <amit.shah@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Richard W.M. Jones <rjones@redhat.com>
Ref: https://bugzilla.redhat.com/show_bug.cgi?id=1383451
Fixes: d9e797261933 ("hwrng: add randomness to system from rng sources")
See-also: 5e59d9a1aed2 ("virtio_console: Stop doing DMA on the stack")
Reported-by: Richard W.M. Jones <rjones@redhat.com>
Tested-by: Richard W.M. Jones <rjones@redhat.com>
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---

Notes:
    - (GFP_NOWAIT | __GFP_NOWARN) could be overly cautious, but I'm better
      safe than sorry.
    
    - If / when responding, please keep me addressed personally; I'm not
      subscribed to either linux-crypto or linux-kernel. Thanks.

 drivers/char/hw_random/core.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 482794526e8c..66831bd5331d 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -50,6 +50,7 @@
 #define PFX			RNG_MODULE_NAME ": "
 #define RNG_MISCDEV_MINOR	183 /* official */
 
+#define EARLY_RANDOMNESS_SIZE	16
 
 static struct hwrng *current_rng;
 static struct task_struct *hwrng_fill;
@@ -84,14 +85,37 @@ static size_t rng_buffer_size(void)
 
 static void add_early_randomness(struct hwrng *rng)
 {
-	unsigned char bytes[16];
+	unsigned char *bytes;
 	int bytes_read;
 
+	/*
+	 * This code can be reached with rng_mutex held, through the following
+	 * call chain:
+	 *
+	 * hwrng_attr_current_store()
+	 *   set_current_rng()
+	 *     hwrng_init()
+	 *       add_early_randomness()
+	 *
+	 * (that is, when a different RNG is selected through the "rng_current"
+	 * sysfs attribute). For that reason, allocate memory without enabling
+	 * sleep.
+	 *
+	 * If the (immediate) allocation fails, we just pretend to have read
+	 * zero bytes from the RNG, as that is already valid behavior. Also,
+	 * feeding initial randomness from the device to the system entropy
+	 * pool is not important enough to tap into emergency memory pools.
+	 */
+	bytes = kmalloc(EARLY_RANDOMNESS_SIZE, GFP_NOWAIT | __GFP_NOWARN);
+	if (!bytes)
+		return;
+
 	mutex_lock(&reading_mutex);
-	bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
+	bytes_read = rng_get_data(rng, bytes, EARLY_RANDOMNESS_SIZE, 1);
 	mutex_unlock(&reading_mutex);
 	if (bytes_read > 0)
 		add_device_randomness(bytes, bytes_read);
+	kfree(bytes);
 }
 
 static inline void cleanup_rng(struct kref *kref)
-- 
2.9.2
