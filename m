From: Farhan Ali <alifm@linux.ibm.com>
Subject: [PATCH v3 0/2] Detect & register virtio-crypto algos only if it can be supported by backend
Date: Tue, 19 Jun 2018 11:41:32 -0400
Message-ID: <cover.1529422492.git.alifm@linux.ibm.com>
Cc: qemu-devel@nongnu.org, herbert@gondor.apana.org.au,
        borntraeger@de.ibm.com, arei.gonglei@huawei.com,
        longpeng2@huawei.com, pasic@linux.ibm.com, frankja@linux.ibm.com,
        jasowang@redhat.com, mst@redhat.com
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

Currently the Linux virtio-crypto driver registers the crypto
algorithm without verifying if the backend actually supports the
algorithm.

This kernel patch series adds support for registering algorithm
with Linux crypto layer, only if the algorithm is supported by
the backend device. This also makes the driver more compliant with
the virtio-crypto spec [1].

I would appreciate any feedback or comments on this.

Thank you
Farhan

Reference
---------
[1] Virtio crypto spec proposal https://lists.gnu.org/archive/html/qemu-devel/2017-12/msg00816.html

ChangeLog
---------
v2 -> v3
    - Add Christian Borntrager's acks for the patches.

v1 -> v2
   - Modify comment as suggested by Arei (patch 1)
   - Modify error message as suggested by Arei (patch 2)

Farhan Ali (2):
  crypto/virtio-crypto: Read crypto services and algorithm masks
  crypto/virtio-crypto: Register an algo only if it's supported

 drivers/crypto/virtio/virtio_crypto_algs.c   | 112 ++++++++++++++++++---------
 drivers/crypto/virtio/virtio_crypto_common.h |  25 +++++-
 drivers/crypto/virtio/virtio_crypto_core.c   |  29 +++++++
 drivers/crypto/virtio/virtio_crypto_mgr.c    |  81 +++++++++++++++++--
 4 files changed, 202 insertions(+), 45 deletions(-)

-- 
2.7.4
