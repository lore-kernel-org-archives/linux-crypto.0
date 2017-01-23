From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 0/6] Add bulk skcipher requests to crypto API and
 dm-crypt
Date: Mon, 23 Jan 2017 21:04:52 +0800
Message-ID: <20170123130452.GA17598@gondor.apana.org.au>
References: <cover.1484215956.git.omosnacek@gmail.com>
 <20170113104128.GA23497@gondor.apana.org.au>
 <CAAUqJDtqN-ugcaz4VhuW0fzLbmKt4db8ggrRmaAq_zFvO+9Lvw@mail.gmail.com>
 <20170113142959.GA24258@gondor.apana.org.au>
 <CAAUqJDsrFp2CczN5Gyy=rYLSDKi7=vQTQoyh=pE1kWue=c=fvw@mail.gmail.com>
 <20170118044828.GB4460@gondor.apana.org.au>
 <CAAUqJDtZNGLW-PcPKJD5vdKMZqd6+sAKrbjqVbaVTQqWwZ4cGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60769 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750718AbdAWNFD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2017 08:05:03 -0500
Content-Disposition: inline
In-Reply-To: <CAAUqJDtZNGLW-PcPKJD5vdKMZqd6+sAKrbjqVbaVTQqWwZ4cGQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 19, 2017 at 03:21:37PM +0100, Ondrej Mosnáček wrote:
> 
> Hm, I just looked at what the IPsec IV generation is actually doing
> and it seems to me that it's basically a crypto template that just
> somehow transforms the IV before it is passed to the child cipher... I
> thought for a while that you were implying that there already is some
> facility in the crypto API that allows submitting multiple messages +
> some initial sequence number that is auto-incremented and IVs are
> generated from the numbers. However, I could not find anything like
> that in the code, so now I think what you meant was just that I should
> somehow pull the actual IV generators into the crypto layer so that
> the IVs can be generated inside the hardware.

IPsec currently only deals with one packet at a time, but the
point is that the IV generator handles everything transparently
and the IV is actually part of the cipher text for the AEAD op.

IOW it would be trivial to extend our current IPsec IV generators
to handle multiple packets as the IVs are embedded with the cipher
text.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
