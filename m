Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BE514006
	for <linux-crypto@vger.kernel.org>; Sat, 11 Nov 2023 11:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A3F3AA0
	for <linux-crypto@vger.kernel.org>; Sat, 11 Nov 2023 03:58:53 -0800 (PST)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1r1mdV-00053d-JP; Sat, 11 Nov 2023 12:58:49 +0100
Message-ID: <36da0242-e9de-4d76-8ba0-fc7522096fad@leemhuis.info>
Date: Sat, 11 Nov 2023 12:58:48 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] dm_crypt essiv ciphers do not use async driver
 mv-aes-cbc anymore
Content-Language: en-US, de-DE
To: Mikulas Patocka <mpatocka@redhat.com>,
 Linux regressions mailing list <regressions@lists.linux.dev>
Cc: Yureka <yuka@yuka.dev>, linux-crypto@vger.kernel.org,
 dm-devel@redhat.com, Boris Brezillon <bbrezillon@kernel.org>,
 Arnaud Ebalard <arno@natisbad.org>, Srujana Challa <schalla@marvell.com>,
 Eric Biggers <ebiggers@kernel.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
References: <53f57de2-ef58-4855-bb3c-f0d54472dc4d@yuka.dev>
 <20230929224327.GA11839@google.com>
 <070dd167-9278-42fa-aef5-66621a602fd3@leemhuis.info>
 <518e373e-673e-82a-24ff-b9e8b3927c85@redhat.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <518e373e-673e-82a-24ff-b9e8b3927c85@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1699703933;43301ff5;
X-HE-SMSGID: 1r1mdV-00053d-JP

On 01.11.23 13:47, Mikulas Patocka wrote:
> On Wed, 1 Nov 2023, Linux regression tracking (Thorsten Leemhuis) wrote:
> 
>>> #regzbot introduced: b8aa7dc5c753
>>
>> BTW: Eric, thx for this.
>>
>> Boris, Arnaud, Srujana, and Mikulas, could you maybe comment on this? I
>> understand that this is not some everyday regression due to deadlock
>> risk, but it nevertheless would be good to get this resolved somehow to
>> stay in line with our "no regressions" rule.
>>
> 
> The driver drivers/crypto/marvell/cesa/cipher.c uses GFP_ATOMIC 
> allocations (see mv_cesa_skcipher_dma_req_init). So, it is not really safe 
> to use it for dm-crypt.
> 
> GFP_ATOMIC allocations may fail anytime (for example, they fill fail if 
> the machine receives too many network packets in a short timeframe and 
> runs temporarily out of memory). And when the GFP_ATOMIC allocation fails, 
> you get a write I/O error and data corruption.
> 
> It could be possible to change it to use GFP_NOIO allocations, then we 
> would risk deadlock instead of data corruption. The best thing would be to 
> convert the driver to use mempools.

Thx, now I understand things better. I also had a small hope that my
prodding here might motivate someone to look into this, but that didn't
happen. Well, that's how it is.

I'm not totally sure if this regression was handled like Linus would
have want it to be handled. But I guess it's not worth bringing him in
-- among others because it took so long for somebody to complain. I'll
thus strop tracking this now.

#regzbot resolve: tricky situation that remains unresolved for now

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.
