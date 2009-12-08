From: avital sela <avitalsela95@gmail.com>
Subject: Re: question about fragmentation of large packets
Date: Tue, 8 Dec 2009 16:53:27 +0200
Message-ID: <311e0d1f0912080653s28ac65ebl26bcf0e4b3ce5a96@mail.gmail.com>
References: <311e0d1f0912080454q6099cc4cq5b23617364bf9633@mail.gmail.com>
	 <20091208125846.GA30136@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:35703 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbZLHOxW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Dec 2009 09:53:22 -0500
Received: by fxm5 with SMTP id 5so6269754fxm.28
        for <linux-crypto@vger.kernel.org>; Tue, 08 Dec 2009 06:53:28 -0800 (PST)
In-Reply-To: <20091208125846.GA30136@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks !

On Tue, Dec 8, 2009 at 2:58 PM, Herbert Xu <herbert@gondor.apana.org.au=
> wrote:
> On Tue, Dec 08, 2009 at 02:54:43PM +0200, avital sela wrote:
>> Hello,
>>
>> I am testing a AES HW crypto driver I wrote. I test by setting up a
>> tunnel between the board and a Linux server and pinging packets from
>> the board to the server.
>> With my driver loaded everything works fine with small packets but
>> large packets (>1500) fail (100% packet loss).
>> I added some debug code to the standard crypto/cbc.c and noticed tha=
t
>> when I ping using -s1500 the encryption (aes-cbc) gets broken up to =
3
>> chuncks
>> sized 1456 , 16, 64. =A0I also noticed that the iv for each of the
>> chunks is different.
>> Questions:
>> 1. Why are there 3 chunks with these sizes? Is this related to the
>> crypto subsystem or the =A0ipsec one?
>
> The chunks 1456/64 is a product of the TCP stack. =A016 is the IV
> added on by IPsec.
>
>> 2. How is the iv computed between each subsequent chunk?
>
> The last cipher (encrypted) block of a chunk should be used as
> the IV for the next chunk.
>
> Cheers,
> --
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
