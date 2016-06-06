From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: Re: [PATCH 2/6] crypto: talitos - making mapping helpers more generic
Date: Mon, 6 Jun 2016 09:03:14 +0200
Message-ID: <1be7c6f6-8885-d008-f47b-9e7f290e0c37@c-s.fr>
References: <cover.1464330501.git.christophe.leroy@c-s.fr>
 <26474a2b44e69a0dbff43dbeed030ab5adef81db.1464330501.git.christophe.leroy@c-s.fr>
 <20160531094651.GA15187@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Kim Phillips <kim.phillips@arm.com>,
	David S Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:57690 "EHLO pegase1.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbcFFHDR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jun 2016 03:03:17 -0400
In-Reply-To: <20160531094651.GA15187@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



Le 31/05/2016 =E0 11:46, Herbert Xu a =E9crit :
> On Fri, May 27, 2016 at 11:32:36AM +0200, Christophe Leroy wrote:
>> +	sg_count =3D sg_to_link_tbl_offset(src, sg_count, offset, len,
>> +					 &edesc->link_tbl[tbl_off])
>> +	if (sg_count =3D=3D 1) {
>> +		/* Only one segment now, so no link tbl needed*/
>> +		copy_talitos_ptr(ptr, &edesc->link_tbl[tbl_off], is_sec1);
>> +		return sg_count;
>> +	}
> This patch doesn't build.
Oops, I was too quick on doing the cosmetic modifications requested by=20
the checkpatch script.
Sorry for that, I will submit a new version this week

Christophe
