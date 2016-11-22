From: Gonglei <arei.gonglei@huawei.com>
Subject: [PATCH v2 0/2] virtio-crypto: add Linux driver
Date: Tue, 22 Nov 2016 16:10:21 +0800
Message-ID: <1479802223-121104-1-git-send-email-arei.gonglei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <luonengjun@huawei.com>, <mst@redhat.com>, <stefanha@redhat.com>,
        <weidong.huang@huawei.com>, <wu.wubin@huawei.com>,
        <xin.zeng@intel.com>, <claudio.fontana@huawei.com>,
        <herbert@gondor.apana.org.au>, <pasic@linux.vnet.ibm.com>,
        <davem@davemloft.net>, <jianjay.zhou@huawei.com>,
        <hanweidong@huawei.com>, <arei.gonglei@hotmail.com>,
        <cornelia.huck@de.ibm.com>, <xuquan8@huawei.com>,
        <longpeng2@huawei.com>, <salvatore.benedetto@intel.com>,
        Gonglei <arei.gonglei@huawei.com>
To: <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <virtio-dev@lists.oasis-open.org>,
        <virtualization@lists.linux-foundation.org>,
        <linux-crypto@vger.kernel.org>
Return-path: <virtio-dev-return-1716-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
List-Id: linux-crypto.vger.kernel.org

The virtio crypto device is a virtual cryptography device
as well as a kind of virtual hardware accelerator for
virtual machines. The encryption anddecryption requests
are placed in the data queue and are ultimately handled by
thebackend crypto accelerators. The second queue is the
control queue used to create or destroy sessions for
symmetric algorithms and will control some advanced features
in the future. The virtio crypto device provides the following
cryptoservices: CIPHER, MAC, HASH, and AEAD.

For more information about virtio-crypto device, please see:
  http://qemu-project.org/Features/VirtioCrypto

For better reviewing:

Patch 1 introduces the little edian functions for VIRTIO_1 
devices.

Patch 2 mainly includes five files:
 1) virtio_crypto.h is the header file for virtio-crypto device,
which is based on the virtio-crypto specification. 
 2) virtio_crypto.c is the entry of the driver module,
which is similar with other virtio devices, such as virtio-net,
virtio-input etc. 
 3) virtio_crypto_mgr.c is used to manage the virtio
crypto devices in the system. We support up to 32 virtio-crypto
devices currently. I use a global list to store the virtio crypto
devices which refer to Intel QAT driver. Meanwhile, the file
includs the functions of add/del/search/start/stop for virtio
crypto devices.
 4) virtio_crypto_common.h is a private header file for virtio
crypto driver, includes structure definations, and function declarations.
 5) virtio_crypto_algs.c is the realization of algs based on Linux Crypto Framwork,
which can register different crypto algorithms. Currently it's only support AES-CBC.
The Crypto guys can mainly focus to this file. 

Actually I have no idea the virtio-crypto driver should be gone in whose
tree, Michael's or Herbert's?

Would you give me a feedback? Thanks a lot!


v2:
 - stop doing DMA from the stack, CONFIG_VMAP_STACK=y [Salvatore]
 - convert __virtio32/64 to __le32/64 in virtio_crypto.h
 - remove VIRTIO_CRYPTO_S_STARTED based on the lastest virtio crypto spec.
 - introduces the little edian functions for VIRTIO_1 devices in patch 1.

Gonglei (2):
  virtio: introduce little edian functions for virtio_cread/write#
    family
  crypto: add virtio-crypto driver

 MAINTAINERS                                  |   8 +
 drivers/crypto/Kconfig                       |   2 +
 drivers/crypto/Makefile                      |   1 +
 drivers/crypto/virtio/Kconfig                |  10 +
 drivers/crypto/virtio/Makefile               |   5 +
 drivers/crypto/virtio/virtio_crypto.c        | 444 +++++++++++++++++++++++
 drivers/crypto/virtio/virtio_crypto_algs.c   | 524 +++++++++++++++++++++++++++
 drivers/crypto/virtio/virtio_crypto_common.h | 124 +++++++
 drivers/crypto/virtio/virtio_crypto_mgr.c    | 258 +++++++++++++
 include/linux/virtio_config.h                |  45 +++
 include/uapi/linux/Kbuild                    |   1 +
 include/uapi/linux/virtio_crypto.h           | 435 ++++++++++++++++++++++
 include/uapi/linux/virtio_ids.h              |   1 +
 13 files changed, 1858 insertions(+)
 create mode 100644 drivers/crypto/virtio/Kconfig
 create mode 100644 drivers/crypto/virtio/Makefile
 create mode 100644 drivers/crypto/virtio/virtio_crypto.c
 create mode 100644 drivers/crypto/virtio/virtio_crypto_algs.c
 create mode 100644 drivers/crypto/virtio/virtio_crypto_common.h
 create mode 100644 drivers/crypto/virtio/virtio_crypto_mgr.c
 create mode 100644 include/uapi/linux/virtio_crypto.h

-- 
1.8.3.1
