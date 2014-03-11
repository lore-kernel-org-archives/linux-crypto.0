From: joeyli <jlee@suse.com>
Subject: Re: [PATCH] crypto: avoid module request when lookup crypto larval
 of template
Date: Tue, 11 Mar 2014 22:02:58 +0800
Message-ID: <1394546578.26565.43.camel@linux-s257.site>
References: <1394443371-12181-1-git-send-email-jlee@suse.com>
	 <20140310115721.GA9657@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:57455 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaCKODm (ORCPT
	<rfc822;groupwise-linux-crypto@vger.kernel.org:0:0>);
	Tue, 11 Mar 2014 10:03:42 -0400
In-Reply-To: <20140310115721.GA9657@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,=20

=E6=96=BC =E4=B8=80=EF=BC=8C2014-03-10 =E6=96=BC 19:57 +0800=EF=BC=8CHe=
rbert Xu =E6=8F=90=E5=88=B0=EF=BC=9A
> On Mon, Mar 10, 2014 at 05:22:51PM +0800, Lee, Chun-Yi wrote:
> > When allocate crypto algorithms, e.g. crypto_alloc_shash(), using
> > template model will run into the path that call module_request().
> > But there have no any module alias that match with the template nam=
e.
>=20
> There aren't any but there could be.  For example, as it is
> all direct implementations of cbc(aes) rely on the fact that
> they also happen to provide aes to autoload themselves.
>=20
> We may well have a case where it makes sense for a module to
> provide just cbc(aes) for example, in which case it would need
> such an alias for it to be loaded automatically.
>=20
> Thanks,

Thanks for your quick explanation!

Joey Lee
