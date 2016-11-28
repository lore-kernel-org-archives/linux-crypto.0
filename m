From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: RE: Re: [PATCH v2 1/2] virtio: introduce little edian
 functions for virtio_cread/write# family
Date: Mon, 28 Nov 2016 02:57:06 +0000
Message-ID: <33183CC9F5247A488A2544077AF19020D97A1087@SZXEMA503-MBS.china.huawei.com>
References: <1479802223-121104-1-git-send-email-arei.gonglei@huawei.com>
 <1479802223-121104-2-git-send-email-arei.gonglei@huawei.com>
 <20161127052802-mutt-send-email-mst@kernel.org>
 <33183CC9F5247A488A2544077AF19020D97A103C@SZXEMA503-MBS.china.huawei.com>
 <20161128042142-mutt-send-email-mst@kernel.org>
 <20161128044845-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>,
        Luonengjun <luonengjun@huawei.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "Huangweidong (C)"
	<weidong.huang@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        "xin.zeng@intel.com" <xin.zeng@intel.com>,
        Claudio Fontana
	<Claudio.Fontana@huawei.com>,
        "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>,
        "pasic@linux.vnet.ibm.com"
	<pasic@linux.vnet.ibm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Zhoujian (jay, Euler)" <jianjay
To: "Michael S. Tsirkin" <mst@redhat.com>
Return-path: <virtio-dev-return-1725-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <20161128044845-mutt-send-email-mst@kernel.org>
Content-Language: zh-CN
List-Id: linux-crypto.vger.kernel.org

>
> Subject: Re: [virtio-dev] Re: [PATCH v2 1/2] virtio: introduce little edi=
an
> functions for virtio_cread/write# family
>=20
> On Mon, Nov 28, 2016 at 04:34:56AM +0200, Michael S. Tsirkin wrote:
> > On Mon, Nov 28, 2016 at 01:56:04AM +0000, Gonglei (Arei) wrote:
> > > Hi Michael,
> > >
> > > Thanks for your feedback firstly!
> > >
> > > > -----Original Message-----
> > > > From: virtio-dev@lists.oasis-open.org
> [mailto:virtio-dev@lists.oasis-open.org]
> > > > On Behalf Of Michael S. Tsirkin
> > > > Sent: Sunday, November 27, 2016 11:33 AM
> > > > To: Gonglei (Arei)
> > > > Subject: [virtio-dev] Re: [PATCH v2 1/2] virtio: introduce little e=
dian
> functions for
> > > > virtio_cread/write# family
> > > >
> > > > On Tue, Nov 22, 2016 at 04:10:22PM +0800, Gonglei wrote:
> > > > > Virtio modern devices are always little edian, let's introduce
> > > > > the LE functions for read/write configuration space for
> > > > > virtio modern devices, which avoid complaint by Sparse when
> > > > > we use the virtio_creaed/virtio_cwrite in VIRTIO_1 devices.
> > > > >
> > > > > Signed-off-by: Gonglei <arei.gonglei@huawei.com>
> > > > > ---
> > > > >  include/linux/virtio_config.h | 45
> > > > +++++++++++++++++++++++++++++++++++++++++++
> > > > >  1 file changed, 45 insertions(+)
> > > > >
> > > > > diff --git a/include/linux/virtio_config.h b/include/linux/virtio=
_config.h
> > > > > index 26c155b..de05707 100644
> > > > > --- a/include/linux/virtio_config.h
> > > > > +++ b/include/linux/virtio_config.h
> > > > > @@ -414,4 +414,49 @@ static inline void virtio_cwrite64(struct
> virtio_device
> > > > *vdev,
> > > > >  		_r;							\
> > > > >  	})
> > > > >
> > > > > +static inline __le16 virtio_cread16_le(struct virtio_device *vde=
v,
> > > > > +				 unsigned int offset)
> > > > > +{
> > > > > +	__le16 ret;
> > > > > +
> > > > > +	vdev->config->get(vdev, offset, &ret, sizeof(ret));
> > > > > +	return ret;
> > > > > +}
> > > > > +
> > > > > +static inline void virtio_cwrite16_le(struct virtio_device *vdev=
,
> > > > > +				   unsigned int offset, __le16 val)
> > > > > +{
> > > > > +	vdev->config->set(vdev, offset, &val, sizeof(val));
> > > > > +}
> > > > > +
> > > > > +static inline __le32 virtio_cread32_le(struct virtio_device *vde=
v,
> > > > > +				 unsigned int offset)
> > > > > +{
> > > > > +	__le32 ret;
> > > > > +
> > > > > +	vdev->config->get(vdev, offset, &ret, sizeof(ret));
> > > > > +	return ret;
> > > > > +}
> > > > > +
> > > > > +static inline void virtio_cwrite32_le(struct virtio_device *vdev=
,
> > > > > +				   unsigned int offset, __le32 val)
> > > > > +{
> > > > > +	vdev->config->set(vdev, offset, &val, sizeof(val));
> > > > > +}
> > > > > +
> > > > > +static inline __le64 virtio_cread64_le(struct virtio_device *vde=
v,
> > > > > +				 unsigned int offset)
> > > > > +{
> > > > > +	__le64 ret;
> > > > > +
> > > > > +	__virtio_cread_many(vdev, offset, &ret, 1, sizeof(ret));
> > > > > +	return ret;
> > > > > +}
> > > > > +
> > > > > +static inline void virtio_cwrite64_le(struct virtio_device *vdev=
,
> > > > > +				   unsigned int offset, __le64 val)
> > > > > +{
> > > > > +	vdev->config->set(vdev, offset, &val, sizeof(val));
> > > > > +}
> > > > > +
> > > > >  #endif /* _LINUX_VIRTIO_CONFIG_H */
> > > >
> > > > Could you please better explain what is the issue you are facing?
> > > > virtio_cwrite/virtio_cread all accept and return native types.
> > > >
> > > virtio_cwrite/virtio_cread are used to write/read configuration
> > > space for virtio devices. For virtio-crypto device, I used __le32/64 =
directly
> > > in struct virtio_crypto_config. The sparse reports warnings if I use
> virtio_cread()
> > > for virtio-crypto device.
> >
> > I suspect that's because you are doing cread into an le32 variable.
> >
> >
> >
> > > Furthermore, it means the warnings exist for all VIRTIO_1 devices bec=
ause
> > > they are definitely LE, which it's not necessary to use
> virtio_to_cpu/cpu_to_virtio.
> > >
> > >
> > > PS: I googled a discussion about this topic for virtio-input device, =
pls see:
> > >
> http://linux.kernel.narkive.com/3argfbWz/patch-1-1-add-virtio-input-drive=
r
> > >
> > > Regards,
> > > -Gonglei
> >
> > Looks like we changed the macros since - at least ATM
> > virtio_console_config uses __u16 fields (which is probably a bug -
> > I'll look into fixing it up) and they
> > do not seem to trigger warnings.
>=20
>=20
> Sorry, I recall now. We use u32 and similar types in the config
> space, and endian-ness is implicit.
> This works fine if you are using virtio_cread interfaces which will swap
> to/from LE for you.
>=20
> What doesn't work correctly is shadowing the whole config space
> using ->get since that does not byte-swap. so just don't do it.
>=20
> I would say just do what everyone does in this version and
> we can revisit this later.
>=20

OK, it's fair. :)=20

Thanks!
-Gonglei

> >
> > > > If you want it in LE format, swap it!
> > > >
> > > >
> > > >
> > > > > --
> > > > > 1.8.3.1
> > > > >
> > > >
> > > > -------------------------------------------------------------------=
--
> > > > To unsubscribe, e-mail: virtio-dev-unsubscribe@lists.oasis-open.org
> > > > For additional commands, e-mail: virtio-dev-help@lists.oasis-open.o=
rg
