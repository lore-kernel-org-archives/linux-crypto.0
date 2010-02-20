From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: Re: [PATCH 05/19] crypto: proc - Fix checkpatch errors
Date: Sat, 20 Feb 2010 02:59:44 +0100
Message-ID: <2d460de71002191759w5241431an92f48de21c9af7af@mail.gmail.com>
References: <1266538925-3245-1-git-send-email-richih.mailinglist@gmail.com>
	 <m1d402t2qp.fsf@fess.ebiederm.org>
	 <2d460de71002190210qb9d5685n2fca0e7eff011b04@mail.gmail.com>
	 <20100219121752.GA21682@gondor.apana.org.au>
	 <2d460de71002190835t29c6bd6bjbee8e2f787d9ab49@mail.gmail.com>
	 <20100220004615.GB30844@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Benjamin Gilbert <bgilbert@cs.cmu.edu>,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:43977 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab0BTB7q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Feb 2010 20:59:46 -0500
In-Reply-To: <20100220004615.GB30844@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Feb 20, 2010 at 01:46, Herbert Xu <herbert@gondor.apana.org.au>=
 wrote:

> I'm just dropping this particular change. =C2=A0If there are any
> other ones where you've done a similar thing, then please either
> revise or drop those.

In this case, please hold seed, tcrypt, wp512 & xcbc. I will
refactor them.

The last batch of patches did not have any of these changes.


Thanks,
Richard
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
