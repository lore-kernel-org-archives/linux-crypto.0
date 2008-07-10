From: austin zhang <austin_zhang@linux.intel.com>
Subject: Re: FW: [Fwd: [PATCH]Using Intel CRC32 instruction to implement
	hardware accelerated CRC32c algorithm.]
Date: Thu, 10 Jul 2008 07:26:09 -0400
Message-ID: <1215689169.5257.7.camel@localhost.localdomain>
References: <000901c8e0d4$6f5cf230$7fb410ac@ccr.corp.intel.com>
	 <1215512754.2906.23.camel@localhost.localdomain>
	 <20080709074153.GA11927@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: davem@davemloft.net, chaapala@cisco.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	arjan@linux.intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>, johnpol@2ka.mipt.ru
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:37063 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751653AbYGJL1E (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jul 2008 07:27:04 -0400
In-Reply-To: <20080709074153.GA11927@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2008-07-09 at 15:41 +0800, Herbert Xu wrote:

> I've just converted the crc32c module over to the new interface.
> You can use this as an example.
Herbert and =EF=BB=BFEvgeniy,
Sorry for late reply. Thanks a lot for your information and example, I
will work out the intel-specific implemetation. After internal
discussing and approval, I will post here for review again.

> Unfortunately this leads to nasty hacks because the existing
> interface does chaining in a way that isn't easily mapped over
> to the crypto API.  However this is no great loss since there
> is a grand total of two users in the tree :)
>=20
> So my plan is to convert them and then remove the libcrc32c
> interface completely.
Because libcrc32c can be a module in original implemetation, so for
those other routine which call crc32c_le directly, this may not work fo=
r
them? =20


--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
