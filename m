From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [CRYPTO] cast6: inline bloat--
Date: Sat, 12 Jan 2008 09:04:47 +0100
Message-ID: <20080112080447.GA26384@Chamillionaire.breakpoint.cc>
References: <Pine.LNX.4.64.0801071535300.31652@kivilampi-30.cs.helsinki.fi> <p73ve62nzzk.fsf@bingen.suse.de> <Pine.LNX.4.64.0801101114070.1408@kivilampi-30.cs.helsinki.fi> <20080110092555.GB25076@one.firstfloor.org> <20080110092746.GA11613@gondor.apana.org.au> <20080110133529.GA13851@Chamillionaire.breakpoint.cc> <20080110154650.GA29453@one.firstfloor.org> <20080112000937.GA23721@Chamillionaire.breakpoint.cc> <20080112005742.GA898@gondor.apana.org.au>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Andi Kleen <andi@firstfloor.org>,
	Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:43736 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759720AbYALIEy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 Jan 2008 03:04:54 -0500
Content-Disposition: inline
In-Reply-To: <20080112005742.GA898@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2008-01-12 11:57:42 [+1100]:

>
>Thanks for following this through!
np

>
>> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
>> index 1ab8c01..a935abc 100644
>> --- a/crypto/tcrypt.c
>> +++ b/crypto/tcrypt.c
>> @@ -1705,6 +1705,12 @@ static void do_test(void)
>>                 test_cipher_speed("salsa20", ENCRYPT, sec, NULL, 0,
>>                                   salsa20_speed_template);
>>                 break;
>> +       case 207:
>> +               test_cipher_speed("ecb(cast6)", ENCRYPT, sec, NULL, 0,
>> +                               camellia_speed_template);
>> +               test_cipher_speed("ecb(cast6)", DECRYPT, sec, NULL, 0,
>> +                               camellia_speed_template);
>> +               break;
>
>Perhaps we should make a generic speed template that works for all
>ciphers?
Most of them aren't that different, I try to make something.

>Cheers,
>-- 
>Visit Openswan at http://www.openswan.org/
>Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
>Home Page: http://gondor.apana.org.au/~herbert/
>PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>-
>To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
