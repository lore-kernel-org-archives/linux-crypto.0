From: Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 0/2] hwrng: revert managed API changes for amd and geode
Date: Tue, 14 Mar 2017 07:36:00 -0400
Message-ID: <1489491362-26339-1-git-send-email-prarit@redhat.com>
Cc: Prarit Bhargava <prarit@redhat.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Corentin LABBE <clabbe.montjoie@gmail.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-crypto@vger.kernel.org, linux-geode@lists.infradead.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When booting top-of-tree the following WARN_ON triggers in the kernel on
a 15h AMD system.

WARNING: CPU: 2 PID: 621 at drivers/base/dd.c:349 driver_probe_device+0x38c
Modules linked in: i2c_amd756(+) amd_rng sg pcspkr parport_pc(+) parport k8
CPU: 2 PID: 621 Comm: systemd-udevd Not tainted 4.11.0-0.rc1.git0.1.el7_UNS
Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./TYAN High-End 
Call Trace:
dump_stack+0x63/0x8e
__warn+0xd1/0xf0
warn_slowpath_null+0x1d/0x20
driver_probe_device+0x38c/0x470
__driver_attach+0xc9/0xf0
? driver_probe_device+0x470/0x470
bus_for_each_dev+0x5d/0x90
driver_attach+0x1e/0x20
bus_add_driver+0x1d0/0x290
driver_register+0x60/0xe0
? 0xffffffffa0037000
__pci_register_driver+0x4c/0x50
amd756_driver_init+0x1e/0x1000 [i2c_amd756]
do_one_initcall+0x51/0x1b0
? __vunmap+0x85/0xd0
? do_init_module+0x27/0x1fa
do_init_module+0x60/0x1fa
load_module+0x15d1/0x1ad0
? m_show+0x1c0/0x1c0
SYSC_finit_module+0xa9/0xd0

There are PCI devices that contain both a RNG and SMBUS device.  The
RNG device is initialized by the amd-rng driver but the driver does not
register against the device.  The SMBUS device is initialized by the
i2c-amd756 driver and registers against the device and hits the WARN_ON()
because the amd-rng driver has already allocated resources against the
device.

The amd-rng driver was incorrectly migrated to the device resource model
(devres), and after code inspection I found that the geode-rng driver was also
incorrectly migrated.  These drivers are using devres but do not register a
driver against the device, and both drivers are expecting a memory cleanup on
a driver detach that will never happen.  This results in a memory leak when the
driver is unloaded and the inability to reload the driver.

Revert 31b2a73c9c5f ("hwrng: amd - Migrate to managed API"), and 6e9b5e76882c
("hwrng: geode - Migrate to managed API").

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Fixes: 31b2a73c9c5f ("hwrng: amd - Migrate to managed API").
Fixes: 6e9b5e76882c ("hwrng: geode - Migrate to managed API")
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Corentin LABBE <clabbe.montjoie@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-geode@lists.infradead.org

Prarit Bhargava (2):
  hwrng: amd - Revert managed API changes
  hwrng: geode - Revert managed API changes

 drivers/char/hw_random/amd-rng.c   |   42 ++++++++++++++++++++++++------
 drivers/char/hw_random/geode-rng.c |   50 +++++++++++++++++++++++++-----------
 2 files changed, 69 insertions(+), 23 deletions(-)

-- 
1.7.9.3
