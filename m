From: Farhan Ali <alifm@linux.ibm.com>
Subject: Re: [PATCH v3 0/2] Detect & register virtio-crypto algos only if it
 can be supported by backend
Date: Wed, 27 Jun 2018 09:22:04 -0400
Message-ID: <92d562ad-9533-48c4-53b7-d7dd8e383a79@linux.ibm.com>
References: <cover.1529422492.git.alifm@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: qemu-devel@nongnu.org, herbert@gondor.apana.org.au,
        borntraeger@de.ibm.com, arei.gonglei@huawei.com,
        longpeng2@huawei.com, pasic@linux.ibm.com, frankja@linux.ibm.com,
        jasowang@redhat.com, mst@redhat.com,
        Farhan Ali <alifm@linux.ibm.com>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1529422492.git.alifm@linux.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Polite ping :)

Would like to know how to merge these patches in the mainline kernel.

Thanks
Farhan

On 06/19/2018 11:41 AM, Farhan Ali wrote:
> Hi,
> 
> Currently the Linux virtio-crypto driver registers the crypto
> algorithm without verifying if the backend actually supports the
> algorithm.
> 
> This kernel patch series adds support for registering algorithm
> with Linux crypto layer, only if the algorithm is supported by
> the backend device. This also makes the driver more compliant with
> the virtio-crypto spec [1].
> 
> I would appreciate any feedback or comments on this.
> 
> Thank you
> Farhan
> 
> Reference
> ---------
> [1] Virtio crypto spec proposal https://lists.gnu.org/archive/html/qemu-devel/2017-12/msg00816.html
> 
> ChangeLog
> ---------
> v2 -> v3
>      - Add Christian Borntrager's acks for the patches.
> 
> v1 -> v2
>     - Modify comment as suggested by Arei (patch 1)
>     - Modify error message as suggested by Arei (patch 2)
> 
> Farhan Ali (2):
>    crypto/virtio-crypto: Read crypto services and algorithm masks
>    crypto/virtio-crypto: Register an algo only if it's supported
> 
>   drivers/crypto/virtio/virtio_crypto_algs.c   | 112 ++++++++++++++++++---------
>   drivers/crypto/virtio/virtio_crypto_common.h |  25 +++++-
>   drivers/crypto/virtio/virtio_crypto_core.c   |  29 +++++++
>   drivers/crypto/virtio/virtio_crypto_mgr.c    |  81 +++++++++++++++++--
>   4 files changed, 202 insertions(+), 45 deletions(-)
> 
