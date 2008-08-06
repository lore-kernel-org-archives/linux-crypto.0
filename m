From: Austin Zhang <austin_zhang@linux.intel.com>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API -V3.
Date: Wed, 06 Aug 2008 07:05:27 -0400
Message-ID: <1218020727.29030.16.camel@localhost.localdomain>
References: <1218000211.4231.23.camel@localhost.localdomain>
	 <20080806094226.GA23685@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, bunk@kernel.org, dwmw2@infradead.org,
	davem@davemloft.net, randy.dunlap@oracle.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Pavel Machek <pavel@suse.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:5885 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754513AbYHFLHN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Aug 2008 07:07:13 -0400
In-Reply-To: <20080806094226.GA23685@atrey.karlin.mff.cuni.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Paval,

Thanks for your comments.=20

On Wed, 2008-08-06 at 11:42 +0200, Pavel Machek wrote:
> Copyright / GPL?
Yes, as : =EF=BB=BF+MODULE_LICENSE("GPL");

> > +#ifdef CONFIG_X86_64
> > +#define REX_PRE "0x48, "
> > +#define SCALE_F 8
> > +#else
> > +#define REX_PRE
> > +#define SCALE_F 4
> > +#endif
>=20
> Ouch...
Any good suggestion will be appreciated.=20

> > +static u32 crc32c_intel_le_hw_byte(u32 crc, unsigned char const *d=
ata, size_t length)
> > +{
> > +	while (length--) {
> > +		__asm__ __volatile__(
>=20
> Are all the underscores neccessary?
What's big impact if keep those underscores? Just keep ANSI C  style.


>=20
> > +		return -1;
>=20
> That's supposed to be errno, right?
Are you suggest "ENODEV"? It's a feature from the device but the device=
 is exact here.=20
And for the crc32c algorithm, there would be possible that several
algorithms registered themselves in crypto and user will don't care
which implementation will server him even the hardware accelerated
implementation don't exist in this processor.=20




--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
