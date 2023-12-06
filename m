Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A60C9;
	Wed,  6 Dec 2023 03:47:47 -0800 (PST)
Received: from kwepemi100024.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4SlbCK2HfszrV0l;
	Wed,  6 Dec 2023 19:43:57 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 kwepemi100024.china.huawei.com (7.221.188.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Dec 2023 19:47:44 +0800
Received: from dggpemm500006.china.huawei.com ([7.185.36.236]) by
 dggpemm500006.china.huawei.com ([7.185.36.236]) with mapi id 15.01.2507.035;
 Wed, 6 Dec 2023 19:47:44 +0800
From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"pasic@linux.ibm.com" <pasic@linux.ibm.com>, "mst@redhat.com"
	<mst@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, wangyangxin <wangyangxin1@huawei.com>
Subject: RE: [PATCH] crypto: virtio-crypto: Handle dataq logic  with tasklet
Thread-Topic: [PATCH] crypto: virtio-crypto: Handle dataq logic  with tasklet
Thread-Index: Adobp2Ma20NfNCVRS52WT53esc9NTAIVDLQAAQ+I38A=
Date: Wed, 6 Dec 2023 11:47:44 +0000
Message-ID: <860e8f2285ae4350af3a14a5367c462a@huawei.com>
References: <b2fe5c6a60984a9e91bd9dea419c5154@huawei.com>
 <ZWmxInHyFboXMWZ6@gondor.apana.org.au>
In-Reply-To: <ZWmxInHyFboXMWZ6@gondor.apana.org.au>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CFilter-Loop: Reflected

Hi Herbert,

> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Friday, December 1, 2023 6:11 PM
> To: Gonglei (Arei) <arei.gonglei@huawei.com>
> Cc: linux-crypto@vger.kernel.org; pasic@linux.ibm.com; mst@redhat.com;
> jasowang@redhat.com; virtualization@lists.linux-foundation.org;
> linux-kernel@vger.kernel.org; wangyangxin <wangyangxin1@huawei.com>;
> Gonglei (Arei) <arei.gonglei@huawei.com>
> Subject: Re: [PATCH] crypto: virtio-crypto: Handle dataq logic with taskl=
et
>=20
> Gonglei Arei <arei.gonglei@huawei.com> wrote:
> > Doing ipsec produces a spinlock recursion warning.
> > This is due to crypto_finalize_request() being called in the upper half=
.
> > Move virtual data queue processing of virtio-crypto driver to tasklet.
> >
> > Fixes: dbaf0624ffa57 ("crypto: add virtio-crypto driver")
> > Reported-by: Halil Pasic <pasic@linux.ibm.com>
> > Signed-off-by: wangyangxin <wangyangxin1@huawei.com>
> > Signed-off-by: Gonglei <arei.gonglei@huawei.com>
> > ---
> > drivers/crypto/virtio/virtio_crypto_common.h |  2 ++
> > drivers/crypto/virtio/virtio_crypto_core.c   | 23 +++++++++++++--------=
--
> > 2 files changed, 15 insertions(+), 10 deletions(-)
>=20
> Patch applied.  Thanks.

Sorry, pls apply version 2 if possible.

Regards,
-Gonglei

> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
