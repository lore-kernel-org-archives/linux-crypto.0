From: zain <zain.wang@rock-chips.com>
Subject: Re: [RFC PATCH v5] Crypto: rockchip/crypto - add hash support for
 crypto engine in rk3288
Date: Mon, 11 Jan 2016 18:26:03 +0800
Message-ID: <5693833B.8050704@rock-chips.com>
References: <1452484647-30260-1-git-send-email-wzz@rock-chips.com>
 <20160111083925.GA23039@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: heiko@sntech.de, davem@davemloft.net, eddie.cai@rock-chips.com,
	linux-rockchip@lists.infradead.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Zain Wang <wzz@rock-chips.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.131]:50178 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758964AbcAKK0G (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jan 2016 05:26:06 -0500
In-Reply-To: <20160111083925.GA23039@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 2016=E5=B9=B401=E6=9C=8811=E6=97=A5 16:39, Herbert Xu wrote:
> On Mon, Jan 11, 2016 at 11:57:27AM +0800, Zain Wang wrote:
>> From: Zain Wang <zain.wang@rock-chips.com>
>>
>> Add md5 sha1 sha256 support for crypto engine in rk3288.
>> This patch can't support multiple updatings because of limited of IC=
,
>> as result, it can't support import and export too.
> As import and export are a required part of the API you have
> to implement them or your algorithm can't even be reigstered.
>
> If you the hardware cannot support them then your choices are
> limited to a software fallback.
>
> Cheers,
Ok! Thanks your comment.
I will add a software fallback like img-hash.c do
