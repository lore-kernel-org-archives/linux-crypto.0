Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9863998B1;
	Mon,  1 Jun 2026 10:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309669; cv=none; b=Dr7Em/WwF1EGZ3HApbYfI4IAOr/cqycKdcHHnMxGcarTqcIUc1hsoFSK8sagOJChM70YvpmiMkoQuuiBBN0ffaL/giPEH77BjRfG+ahSVsVvGaRsSB7+D2zFuTcnIkwBUFIfbAWcR/LaF7sWQ0DlRWtI1qcdKMckrjLse27p/58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309669; c=relaxed/simple;
	bh=/+ovdbTnun6vIGzP3VH8YfVQ6p+n01wL/EDUhc6ssns=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XJoiLD3O8ZEts15wYywXhvW3+wrg5WqeD/8wD+WCaE92fxx/N9wSWtqMUceKU5QD1xdmy2u52fgyQe690I9JOD6N0S6qzn9mjeXlIKewwxpykWcM18Neidflx45OuEJebDGJGPgB+bT1oHFBRPmHD5VhDff1UQG1MF10CuWVw3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J8fJvH9L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J8fJvH9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74EB01F00893;
	Mon,  1 Jun 2026 10:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780309668;
	bh=TFZUDwwDaz4DB3+5j828fVsrtGXOIYTyT5BX+fU3TuI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=J8fJvH9LYMXZs2G4P+6773InbULCa7YVWtk5ofIDhoF99Lh6bOE69VnUxWSaxEdLx
	 BH0mBsqKV+Bo3Q9/JPldbxLi+EH9Itp9L7qCatstdCciGnqdsYQeTEr8UaNacJ43t4
	 8KBQ4+FYrwb8IkfNuuxfdTPZnf+miJnX32M/pB+7ke6/jmR38JFtJ95gi/RJNzD4+C
	 Wk5outhTz1dLjvkvXWVnNaJkvAi+fKidySU3tC3NluFz/ygbDHVEcqlGgGvRDFDALy
	 6jKhO07Vx/KyRcixnF+LnOLzF0wtVM72lAbezD7vGaAlWKlKFkQyxBnuWVvugAXT9I
	 L9VuiNqbJbazg==
Message-ID: <28d25888-3971-4609-a0d9-db38d1e71eac@kernel.org>
Date: Mon, 1 Jun 2026 12:27:44 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/29] crypto: talitos - Driver cleanup
To: Paul Louvel <paul.louvel@bootlin.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <1488f7b3-cda0-4267-827c-fae23b17c1e8@kernel.org>
 <DIXLMBNKMF1N.2FVTXFA6MP1NF@bootlin.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <DIXLMBNKMF1N.2FVTXFA6MP1NF@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 01/06/2026 à 11:17, Paul Louvel a écrit :
>>> The Freescale Integrated Security Engine (SEC) aka "Talitos" driver
>>> implementation is a monolithic ~3800-line file that mixes SEC1 and SEC2
>>> hardware variants with hash, skcipher, aead and hwrng algorithm.
>>>
>>> This series reorganises the driver to improve readability and
>>> maintainability.
>>
>> Did you analyse the cost of this series ? bloat-o-meter gives the
>> following result, allthough I'm a bit surprised there are only added
>> items, no removed items:
> 
> When you say 'cost', do you mean cost in terms of code size ? performance cost ?
> or both ?
> Regarding code size, I trusted the differences shown in the cover letter by git:
> 
>> 13 files changed, 3810 insertions(+), 3707 deletions(-)

No I mean cost in terms of text size, and cost in terms of execution flow.

> 
> There is 103 insertions more than deletions. This is due to the fact that
> splitting up SEC1/SEC2 code requires additional function and structures.
> I find it acceptable given the readability improvement.
> 
> As for performance, I ran ftrace with the function graph tracer, hashing a 100kb
> file.

The thing is you are doing a test in an ideal world. But the cost can be 
a lot higher on a busy board where you have to consider task switches, 
cache loading, etc ....
The best is to look at the object text. The more flat it is the most 
efficient it is. No branching, no function calls in fast pathes.

When you take a function like this:

00001b14 <to_talitos_ptr>:
     1b14:       2c 06 00 00     cmpwi   r6,0
     1b18:       90 83 00 04     stw     r4,4(r3)
     1b1c:       41 82 00 0c     beq     1b28 <to_talitos_ptr+0x14>
     1b20:       b0 a3 00 02     sth     r5,2(r3)
     1b24:       4e 80 00 20     blr
     1b28:       b0 a3 00 00     sth     r5,0(r3)
     1b2c:       98 c3 00 03     stb     r6,3(r3)
     1b30:       4e 80 00 20     blr

You see that is case is_sec1 is 1 it is just two stores, when is_sec1 is 
0 it is three stores. So inlining those two/three stores at build is 
definitely more efficient than having such a function.

And it is even worth with that one:

00001b84 <to_talitos_ptr_ext_set>:
     1b84:       2c 05 00 00     cmpwi   r5,0
     1b88:       4c 82 00 20     bnelr
     1b8c:       98 83 00 02     stb     r4,2(r3)
     1b90:       4e 80 00 20     blr

If is_sec1 is not 0 the function does nothing, so all the cost of a 
function call to do nothing at the end.


> 
> It looks like there is a slight performance penalty with ahash_finup().
> Otherwise, there is a slight performance improvement for the other measurements.
> I do not know if there is a better way to measure the performance impact of this
> series. If you know, do not hesitate to share it to me.

With experience, the best way to evaluate performance impact is ... look 
at generated object text.

> 
> 
> Best regards,
> Paul.
> 

