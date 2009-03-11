From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: linux-next: Tree for March 10 (crypto & NLATTR)
Date: Wed, 11 Mar 2009 13:25:09 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0903111324400.1040@vixen.sonytel.be>
References: <49B6B821.5050302@oracle.com> <10f740e80903101256v2cfe08a8g410c297e019d8693@mail.gmail.com> <49B6C8BF.8010105@oracle.com> <20090310.131700.40129006.davem@davemloft.net> <20090311010705.GA17260@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Miller <davem@davemloft.net>, randy.dunlap@oracle.com,
	sfr@canb.auug.org.au, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20090311010705.GA17260@gondor.apana.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 11 Mar 2009, Herbert Xu wrote:
> On Tue, Mar 10, 2009 at 01:17:00PM -0700, David Miller wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > Date: Tue, 10 Mar 2009 13:08:31 -0700
> >=20
> > > I'll have to let David or Herbert answer that.  From my quick loo=
k
> > > at the code, I don't see much use for nlattr.c when CONFIG_NET
> > > is not enabled.
> >=20
> > We want to use the netlink attribute parsers even in non-networking
> > code, that's what he's trying to do here.
>=20
> OK the nlattr construction code really wants to depend on NET
> because they're skb-oriented.  We could either move them back
> or just wrap them in ifdef CONFIG_NET.
>=20
> I think the latter is probably the simplest.
>=20
> How does this patch look? And Randy, does it fix the problem for
> you?
>=20
> nlattr: Fix build error with NET off
>=20
> We moved the netlink attribute support from net to lib in order
> for it to be available for general consumption.  However, parts
> of the code (the bits that we don't need :) really depends on
> NET because the target object is sk_buff.
>=20
> This patch fixes this by wrapping them in CONFIG_NET.
>=20
> Some EXPORTs have been moved to make this work.
>=20
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks for taking care of this!

Tested-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

> diff --git a/lib/nlattr.c b/lib/nlattr.c
> index 56c3ce7..80009a2 100644
> --- a/lib/nlattr.c
> +++ b/lib/nlattr.c
> @@ -281,6 +281,7 @@ int nla_strcmp(const struct nlattr *nla, const ch=
ar *str)
>  	return d;
>  }
> =20
> +#ifdef CONFIG_NET
>  /**
>   * __nla_reserve - reserve room for attribute on the skb
>   * @skb: socket buffer to reserve room on
> @@ -305,6 +306,7 @@ struct nlattr *__nla_reserve(struct sk_buff *skb,=
 int attrtype, int attrlen)
> =20
>  	return nla;
>  }
> +EXPORT_SYMBOL(__nla_reserve);
> =20
>  /**
>   * __nla_reserve_nohdr - reserve room for attribute without header
> @@ -325,6 +327,7 @@ void *__nla_reserve_nohdr(struct sk_buff *skb, in=
t attrlen)
> =20
>  	return start;
>  }
> +EXPORT_SYMBOL(__nla_reserve_nohdr);
> =20
>  /**
>   * nla_reserve - reserve room for attribute on the skb
> @@ -345,6 +348,7 @@ struct nlattr *nla_reserve(struct sk_buff *skb, i=
nt attrtype, int attrlen)
> =20
>  	return __nla_reserve(skb, attrtype, attrlen);
>  }
> +EXPORT_SYMBOL(nla_reserve);
> =20
>  /**
>   * nla_reserve_nohdr - reserve room for attribute without header
> @@ -363,6 +367,7 @@ void *nla_reserve_nohdr(struct sk_buff *skb, int =
attrlen)
> =20
>  	return __nla_reserve_nohdr(skb, attrlen);
>  }
> +EXPORT_SYMBOL(nla_reserve_nohdr);
> =20
>  /**
>   * __nla_put - Add a netlink attribute to a socket buffer
> @@ -382,6 +387,7 @@ void __nla_put(struct sk_buff *skb, int attrtype,=
 int attrlen,
>  	nla =3D __nla_reserve(skb, attrtype, attrlen);
>  	memcpy(nla_data(nla), data, attrlen);
>  }
> +EXPORT_SYMBOL(__nla_put);
> =20
>  /**
>   * __nla_put_nohdr - Add a netlink attribute without header
> @@ -399,6 +405,7 @@ void __nla_put_nohdr(struct sk_buff *skb, int att=
rlen, const void *data)
>  	start =3D __nla_reserve_nohdr(skb, attrlen);
>  	memcpy(start, data, attrlen);
>  }
> +EXPORT_SYMBOL(__nla_put_nohdr);
> =20
>  /**
>   * nla_put - Add a netlink attribute to a socket buffer
> @@ -418,6 +425,7 @@ int nla_put(struct sk_buff *skb, int attrtype, in=
t attrlen, const void *data)
>  	__nla_put(skb, attrtype, attrlen, data);
>  	return 0;
>  }
> +EXPORT_SYMBOL(nla_put);
> =20
>  /**
>   * nla_put_nohdr - Add a netlink attribute without header
> @@ -436,6 +444,7 @@ int nla_put_nohdr(struct sk_buff *skb, int attrle=
n, const void *data)
>  	__nla_put_nohdr(skb, attrlen, data);
>  	return 0;
>  }
> +EXPORT_SYMBOL(nla_put_nohdr);
> =20
>  /**
>   * nla_append - Add a netlink attribute without header or padding
> @@ -454,20 +463,13 @@ int nla_append(struct sk_buff *skb, int attrlen=
, const void *data)
>  	memcpy(skb_put(skb, attrlen), data, attrlen);
>  	return 0;
>  }
> +EXPORT_SYMBOL(nla_append);
> +#endif
> =20
>  EXPORT_SYMBOL(nla_validate);
>  EXPORT_SYMBOL(nla_parse);
>  EXPORT_SYMBOL(nla_find);
>  EXPORT_SYMBOL(nla_strlcpy);
> -EXPORT_SYMBOL(__nla_reserve);
> -EXPORT_SYMBOL(__nla_reserve_nohdr);
> -EXPORT_SYMBOL(nla_reserve);
> -EXPORT_SYMBOL(nla_reserve_nohdr);
> -EXPORT_SYMBOL(__nla_put);
> -EXPORT_SYMBOL(__nla_put_nohdr);
> -EXPORT_SYMBOL(nla_put);
> -EXPORT_SYMBOL(nla_put_nohdr);
>  EXPORT_SYMBOL(nla_memcpy);
>  EXPORT_SYMBOL(nla_memcmp);
>  EXPORT_SYMBOL(nla_strcmp);
> -EXPORT_SYMBOL(nla_append);

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =B7 Da Vincilaan 7-D1 =B7 B-1935 Zaventem =B7 Bel=
gium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =B7 RPR Brussels
=46ortis =B7 BIC GEBABEBB =B7 IBAN BE41293037680010
