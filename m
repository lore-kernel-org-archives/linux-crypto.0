From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 1/2] virtio: introduce little edian functions for
	virtio_cread/write# family
Date: Sun, 27 Nov 2016 05:32:53 +0200
Message-ID: <20161127052802-mutt-send-email-mst@kernel.org>
References: <1479802223-121104-1-git-send-email-arei.gonglei@huawei.com>
	<1479802223-121104-2-git-send-email-arei.gonglei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: virtio-dev@lists.oasis-open.org, weidong.huang@huawei.com,
	claudio.fontana@huawei.com, hanweidong@huawei.com,
	qemu-devel@nongnu.org, luonengjun@huawei.com, linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	salvatore.benedetto@intel.com, xuquan8@huawei.com,
	linux-crypto@vger.kernel.org, stefanha@redhat.com,
	jianjay.zhou@huawei.com, longpeng2@huawei.com,
	arei.gonglei@hotmail.com, davem@davemloft.net,
	wu.wubin@huawei.com, herbert@gondor.apana.org.au
To: Gonglei <arei.gonglei@huawei.com>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1479802223-121104-2-git-send-email-arei.gonglei@huawei.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 22, 2016 at 04:10:22PM +0800, Gonglei wrote:
> Virtio modern devices are always little edian, let's introduce
> the LE functions for read/write configuration space for
> virtio modern devices, which avoid complaint by Sparse when
> we use the virtio_creaed/virtio_cwrite in VIRTIO_1 devices.
> 
> Signed-off-by: Gonglei <arei.gonglei@huawei.com>
> ---
>  include/linux/virtio_config.h | 45 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index 26c155b..de05707 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -414,4 +414,49 @@ static inline void virtio_cwrite64(struct virtio_device *vdev,
>  		_r;							\
>  	})
>  
> +static inline __le16 virtio_cread16_le(struct virtio_device *vdev,
> +				 unsigned int offset)
> +{
> +	__le16 ret;
> +
> +	vdev->config->get(vdev, offset, &ret, sizeof(ret));
> +	return ret;
> +}
> +
> +static inline void virtio_cwrite16_le(struct virtio_device *vdev,
> +				   unsigned int offset, __le16 val)
> +{
> +	vdev->config->set(vdev, offset, &val, sizeof(val));
> +}
> +
> +static inline __le32 virtio_cread32_le(struct virtio_device *vdev,
> +				 unsigned int offset)
> +{
> +	__le32 ret;
> +
> +	vdev->config->get(vdev, offset, &ret, sizeof(ret));
> +	return ret;
> +}
> +
> +static inline void virtio_cwrite32_le(struct virtio_device *vdev,
> +				   unsigned int offset, __le32 val)
> +{
> +	vdev->config->set(vdev, offset, &val, sizeof(val));
> +}
> +
> +static inline __le64 virtio_cread64_le(struct virtio_device *vdev,
> +				 unsigned int offset)
> +{
> +	__le64 ret;
> +
> +	__virtio_cread_many(vdev, offset, &ret, 1, sizeof(ret));
> +	return ret;
> +}
> +
> +static inline void virtio_cwrite64_le(struct virtio_device *vdev,
> +				   unsigned int offset, __le64 val)
> +{
> +	vdev->config->set(vdev, offset, &val, sizeof(val));
> +}
> +
>  #endif /* _LINUX_VIRTIO_CONFIG_H */

Could you please better explain what is the issue you are facing?
virtio_cwrite/virtio_cread all accept and return native types.

If you want it in LE format, swap it!



> -- 
> 1.8.3.1
> 
