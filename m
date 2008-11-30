From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: next-20081125: crypto hard disk gets unaccessable
Date: Sat, 29 Nov 2008 19:29:39 -0800
Message-ID: <20081129192939.925275f0.akpm@linux-foundation.org>
References: <20081128063355.GA4700@denkbrett.schottelius.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Christophe Saout <christophe@saout.de>, LKML <linux-kernel@vger.kernel.org>,
	Herbert, dm-devel@redhat.com, linux-next@vger.kernel.org,
	linux-crypto@vger.kernel.org, Xu <herbert@gondor.apana.org.au>
To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081128063355.GA4700@denkbrett.schottelius.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

(cc's added)

On Fri, 28 Nov 2008 07:33:55 +0100 Nico -telmich- Schottelius <nico-linux-next@schottelius.org> wrote:

> Hello!
> 
> After about four suspend & resume operations in the midst of editing
> a file, the system beeped twice and issued this error:
> 
> [69186.618730] note: kcryptd[2848] exited with preempt_count 2
> 
> [full call trace attached]
> 
> /dev/sda3 was mapped via cryptsetup luksOpen to /dev/mapper/home
> and also mounted an home.
> 
> After that error, all accesses to /home hung. Access to /
> (provided by sda1) were still working.
> 
> System is again the Lenovo X200, including sierra loaded and used.
> 
> ...
>

[lots of snippage]

> [69134.199241] device ppp0 left promiscuous mode
> [69186.618203] general protection fault: 0000 [#1] PREEMPT SMP 
> [69186.618216] last sysfs file: /sys/class/power_supply/BAT0/energy_full
> [69186.618220] CPU 0 
> [69186.618224] Modules linked in: ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async crc_ccitt ppp_generic slhc sierra usbserial usb_storage libusual nfs lockd nfs_acl sunrpc iwlagn tun sg usblp sr_mod cdrom vfat fat i915 drm rfcomm l2cap uinput autofs4 ipv6 cpufreq_powersave sha256_generic ansi_cprng krng chainiv rng aes_x86_64 aes_generic cbc dm_crypt dm_mod md_mod loop btusb bluetooth arc4 ecb cryptomgr aead crypto_blkcipher crypto_hash snd_hda_intel snd_pcm snd_page_alloc snd_hwdep snd_seq snd_timer snd_seq_device i2c_i801 rtc_cmos rtc_core snd rtc_lib iwlcore i2c_core pcspkr soundcore mac80211 cfg80211 ehci_hcd video output uhci_hcd wmi usbcore e1000e intel_agp thinkpad_acpi rfkill hwmon backlight led_class nvram [last unloaded: iwlagn]
> [69186.618352] Pid: 2848, comm: kcryptd Not tainted 2.6.28-rc6-next-20081125-denkbrett #15
> [69186.618357] RIP: 0010:[<ffffffff8031f246>]  [<ffffffff8031f246>] crypto_xor+0x7/0x48
> [69186.618372] RSP: 0018:ffff880079879cc8  EFLAGS: 00010212
> [69186.618377] RAX: 00000000fffffff0 RBX: b6e3880000000010 RCX: 0000000000000000
> [69186.618382] RDX: 0000000000000010 RSI: b6e3880000000000 RDI: ffff88007a3da4e0
> [69186.618387] RBP: 0000000000000010 R08: 0000000000000010 R09: 0000000000000000
> [69186.618392] R10: 0000000000000000 R11: ffff88007a3da4e0 R12: 0000000000000010
> [69186.618397] R13: ffff88000c8c9000 R14: ffff88007a3da4e0 R15: 00000000000001f0
> [69186.618403] FS:  0000000000000000(0000) GS:ffffffff805f51c0(0000) knlGS:0000000000000000
> [69186.618408] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [69186.618413] CR2: 00007f56a00ef000 CR3: 0000000053dc9000 CR4: 00000000000006e0
> [69186.618418] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [69186.618423] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [69186.618429] Process kcryptd (pid: 2848, threadinfo ffff880079878000, task ffff88007c2f23a0)
> [69186.618433] Stack:
> [69186.618436]  ffffffffa027226a ffffffff805e1e00 ffff880079879db0 ffff88007ad33800
> [69186.618444]  ffff88007b400360 ffffffffa0285705 fffffff000011212 0000000000000000
> [69186.618453]  b6e3880000000000 ffffe200002bebf8 ffff88000c8c9000 ffff88007a3da4a0
> [69186.618462] Call Trace:
> [69186.618468]  [<ffffffffa027226a>] ? crypto_cbc_encrypt+0xfa/0x15a [cbc]
> [69186.618481]  [<ffffffffa0285705>] ? aes_encrypt+0x0/0x7 [aes_x86_64]
> [69186.618494]  [<ffffffffa020667d>] ? async_encrypt+0x35/0x3a [crypto_blkcipher]
> [69186.618509]  [<ffffffffa0269a6f>] ? crypt_convert+0x1d2/0x253 [dm_crypt]
> [69186.618522]  [<ffffffffa0269ed6>] ? kcryptd_crypt+0x3e6/0x407 [dm_crypt]
> [69186.618533]  [<ffffffffa0269af0>] ? kcryptd_crypt+0x0/0x407 [dm_crypt]
> [69186.618543]  [<ffffffff80241704>] ? run_workqueue+0x87/0x122
> [69186.618552]  [<ffffffff80241877>] ? worker_thread+0xd8/0xe7
> [69186.618560]  [<ffffffff80244e00>] ? autoremove_wake_function+0x0/0x2e
> [69186.618569]  [<ffffffff8024179f>] ? worker_thread+0x0/0xe7
> [69186.618575]  [<ffffffff8024179f>] ? worker_thread+0x0/0xe7
> [69186.618582]  [<ffffffff80244ae7>] ? kthread+0x47/0x73
> [69186.618589]  [<ffffffff8020c4e9>] ? child_rip+0xa/0x21
> [69186.618597]  [<ffffffff80244aa0>] ? kthread+0x0/0x73
> [69186.618604]  [<ffffffff8020c4df>] ? child_rip+0x0/0x21
> [69186.618611] Code: 08 48 89 51 08 48 89 0a 48 b9 00 01 10 00 00 00 ad de 48 ba 00 02 20 00 00 00 ad de 48 89 08 48 89 50 08 c3 41 89 d0 31 c9 eb 0e <8b> 04 0e 41 83 e8 04 31 04 0f 48 83 c1 04 41 83 f8 03 77 ec 41 
> [69186.618678] RIP  [<ffffffff8031f246>] crypto_xor+0x7/0x48
> [69186.618686]  RSP <ffff880079879cc8>
> [69186.618723] ---[ end trace 728c95da3be59caf ]---
> [69186.618730] note: kcryptd[2848] exited with preempt_count 2
> 

Either a bug in dm-crypt or in crypto core, I'd guess.

I assume that 2.6.28-rc6 is OK?
