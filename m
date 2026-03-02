Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 726D3390988;
	Mon,  2 Mar 2026 21:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772488305; cv=none; b=mmcajE4WVKBAMrum0VQmVLJx2Ap+cmk/n4YEXv2Y5f+xQww0A5YONNgIKVNCul9Xmu9wpqR7uqgM2b2An46uDU6QLsrH+RNDfmXGBrjcSbijhR1m4zcPrPnj9CNrS1JycrSQO7PjDpApX3cFsxGo5QCP61RxBAP1ndGhUnvGSSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772488305; c=relaxed/simple;
	bh=pAv1UjKHbLFxxYTgXmloHNcU12ngRy22Ih01kCOwNkA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qd0vwkuiT0Zs1dZ+xuQ7v6tfrmlrqoNFed44oT9H9mWPpMuwF4CTBWdhZDaslkucYjPW84rjnrRXXJKGrJlJUbe+DuxXp1hFLh1PFE57Lfa20/e6wDsvZFAx37riXj1S6TPdCWm7KoYURhruqhgf/phHjlwtvNgkT1a/bKr9ZTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=DBk5g9PM; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="DBk5g9PM"
Received: from [100.96.208.169] (unknown [52.167.112.163])
	by linux.microsoft.com (Postfix) with ESMTPSA id 8574720B6F02;
	Mon,  2 Mar 2026 13:51:39 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8574720B6F02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1772488300;
	bh=ZHxFmIknZ+0QgiBQwKCkTvdBiIMTNhprpcly4IFYIvs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DBk5g9PMyLTyk9hjb8g/m/Twp+Enbu1bkmzZIGsL4eX3+rL3/SAGyvrxpmVDuLkPC
	 nK11OFkTwUopyi6pTJo7fbQDhx0HpBC4YVjlBlZoGxI7qwhm5AKHlDmpuimcAV4+Ww
	 BFsTMRFr5WCWmtUJ1HW9PSt67Dn1AuBwCePTKB6k=
Message-ID: <145cfedf-7510-44b7-b1b7-6569144e7b21@linux.microsoft.com>
Date: Mon, 2 Mar 2026 16:51:38 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: aead: add service indicator flag for RFC4106
 AES-GCM
To: Joachim Vandersmissen <git@jvdsn.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jeff Barnes <jeffbarnes@microsoft.com>
References: <20260129-fips-gcm-clean-v1-v1-1-43e17dc20a1a@microsoft.com>
 <aXw9Wj19ZX6dpNHW@gondor.apana.org.au>
 <ce1d34d9-23f9-4d1e-b790-6af75d1555ed@linux.microsoft.com>
 <aaKtujHwV0zDFWxi@gondor.apana.org.au>
 <a73a2556-3fa3-45fc-bf06-a62e8367e953@jvdsn.com>
Content-Language: en-US
From: Jeff Barnes <jeffbarnes@linux.microsoft.com>
Autocrypt: addr=jeffbarnes@linux.microsoft.com; keydata=
 xsDNBGkBJ6oBDADGnUhy8tjRfb8nx3634KFR2m14JTmgBddmbZdEqjMe3pb4OqBiwSGeOZxo
 GNHFwvE2FRpicGa/s826k75UU+5x4zyye2YDWnYVM/+zY0X8NeOZpWzj/h2uO4BUf4HzeXAS
 rfs0pY+zxbS+Q6td0CC9v6QFy/CeT2E8+Eg0r9cJNgNYgSOa+C7VWHurfR3Y/19yx54QsrDd
 fGEMcpzCU6oBTdFsHs6e6lOxT3hK4Se18q1R+ctiluE8F/iEWt6/vTZ4HGjoBlJEdwoZctSl
 WEhXcabMSI6JVmRlOcW+htoBXI/+drUM9O4yzlTSRD4TItl++//IA6ZlE1kVep8kcfRCykbc
 Ex4LP69xHSsWBJQcfZ2rqcBrUmFNSJZVCsrW5s3PvsC9HqjVG2rySMglqLNU4u3QwWLTGVDM
 00BhwXe56TKHgBQI3bh74ix9ZrsZhaX+KB2PWYXl7wTqavPdlREp01fgOZ84tiEybDVsT0r5
 LExasyAF2W7QmttGQKVacE0AEQEAAc0vSmVmZnJleSBCYXJuZXMgPGplZmZiYXJuZXNAbGlu
 dXgubWljcm9zb2Z0LmNvbT7CwQ4EEwEKADgWIQTVVQl7Aq4c7bMEXSLUqoTFqWH6fAUCaQI4
 IQIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRDUqoTFqWH6fA4CC/4kyMklMHeHBRgI
 16UDNRyJuJYXJK8BVdLtxo7b15dRteg4Gnr9fsmGMc3W7P7PwyZvTfyQgf8Lz5m0fkrrDIP/
 e6ufhDZOswCmIrhhtoUlafVicxDv1ehIEG4x9phGXOPeKR5uyndin89Qg2jyBEkba3Iayyip
 atmN6Y9ZTNV6W8XpUAGbMBQzfbNZpKLw1n3yhyuPNtgRh9EFuNBlXUcNknyTAx4puwRbu9nj
 PYCO3r4jH5QgyyuyaU0hJhvbk090EbYCbIHb6/3jkjAbnw5vAVDCLTU87gJ252/XIxzHC5NV
 0Q7mwh4he/nt/DlBfQK/xplt8zISSKQGkB5yhT+2HtYoU/+oaTyN3KRUM6b65Hiy6yM0jIr3
 Hci3kh2Zc9TAzVnAr6wLf7FpSMqEZIiRzoKIpndkM58CsTczs+LX00S0RjpyzgArQbmb2hUh
 sefqf5qZNcCHdqHRwCMYmHKgbpakTLOADgEVwRH7UZ1n8WU9S5QQNG2rvnz3ZtRdq9TOwM0E
 aQEnqgEMALjFXsW0wibSQw5qT8SQjGCOSYLanA2unv8nVmBDKIvD4wcI2DbImAA5xJSX0nsj
 cMIVmVf7vQ4J7jBxKhHF+H6GXCKD3tHbfM4eRBnxUdqLukOQxHRyixdC0Ehsy0XND5axKJ+t
 um9xaL5kDp7lT95ehd7tJhJhA66tS9AWIjDzFa8hvQSTJtKbl2Oppxqqx51Czta2b04T943Y
 NdOUAtbCSk6Drj8xM+NEoml2wvUEeVBj3Bvu4eVUUk9ewcr1RHmhfsQ39WSRenqQ0aMQJUNR
 YFYBgQ2ZIAa1EeOpWJSgL6riX8+s6MNbu1rYE8fltl559T2Fxw4g1wgxxjJFRAQYF0OgINku
 QU9KiNXlA6B06JE4jpLd0VDhMpXNaZJc2+CNMv68RcHzosDmqvRQPnY9psvPNlzFaZyXl7Sw
 ZJOMsf2vJzVClvfO2xZKtXI3FKR0ghMxOVY3l17f6K+tDDROoApQl4CyDhgqxx+pX2JLS75Z
 rIAL3S2r6e+IHmg88wARAQABwsD2BBgBCgAgFiEE1VUJewKuHO2zBF0i1KqExalh+nwFAmkB
 J6oCGwwACgkQ1KqExalh+nwBCwwAnSJLBvGiSpgSpACxdn4F3Lj4JAJAdL7qaP4WP1OyUEyI
 hl80UPZj9XuME/tPQOwj03AYfchxdIifDBktl6PksaCtvSKJur0tcWlt1cwhxScf2MHtGMun
 t6ONu+xXiwYuNXnWOLrGbe0wGx7vSQC1rAiiEjoEnrHEzaKp+1+7BAVUxrT87YdlKcQnhtfD
 Ry0004j8DYe96mTFM7FlpQXDrFXjwKssDMUTvywhdtGBEluhLL5gPs0lMJNpoJ3pVQ9SLjsg
 U9ZFyIChAd7WfTwFOwqvTpgeVxDmAKAQA/xnqTpZDDA0wmdfaSBPRgvDWBDkm86k4tuMJuI6
 WUUG1t2+lEfSDD0BXiUN7APrtFN/vI2NhSfUgz402TCvGf5TtTWvMHuBQfu0DNLC1DPxmjrT
 fLn7/uZt8Fj8dbfSux0d+13S7zyouz0a0tYWkVsoI3wUAi4rx4gAcoP1OMqUZcsVCY7vYtQQ
 BR++r9M2JSHIgP5LESF8KrBJ6s2f4TqSBCpQ
In-Reply-To: <a73a2556-3fa3-45fc-bf06-a62e8367e953@jvdsn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/1/26 15:41, Joachim Vandersmissen wrote:
> Hi Herbert,
>
> On 2/28/26 2:56 AM, Herbert Xu wrote:
>> On Tue, Feb 17, 2026 at 03:59:41PM -0500, Jeff Barnes wrote:
>>> I don't know how to accomplish that.
>>>
>>> SP800-38D provides two frameworks for constructing a gcm IV. 
>>> (https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-38d.pdf)
>>>
>>> The first construction, described in Sec. 8.2.1, relies on 
>>> deterministic
>>> elements to achieve the uniqueness requirement in Sec. 8; the second
>>> construction, described in Sec. 8.2.2, relies on a sufficiently long 
>>> output
>>> string from an approved RBG with a sufficient security strength. My 
>>> patch
>>> checks for an implementation of 8.2.1 via rfc4106(gcm(aes)). I don't 
>>> know
>>> how a patch could check for 8.2.1 or 8.2.2 from an externally 
>>> generated iv.
>>>
>>> Suggestions welcome.
>> Rather than setting the FIPS_COMPLIANCE flag, why not simply ban the
>> non-compliant cases from being used in FIPS mode?
>>
>> Sure that would mean banning gcm(aes) in FIPS mode, and only
>> allowing seqiv(gcm(aes)) but that's OK because we have the
>> FIPS_INTERNAL flag to deal with this by only allowing gcm(aes)
>> to be used to construct something like seqiv(gcm(aes)).
>
> Like you said, this could work for seqiv(gcm(aes)), if there are truly 
> no usecases for gcm(aes) when the kernel is in FIPS mode.


For instance, ceph, samba, tls, to name a few. They all instantiate the 
gcm(aes) template. They all construct their own IV. They are all 
compliant to SP 800-38d. I am pretty sure that at least one constructs 
it per 8.2.2 while the rest construct per 8.2.1.

There is a good case for asserting "the kernel crypto api is FIPS 
compliant, for out-of-tree modules, you're on your own". But that's 
where the need for the service indicator arises. I'm sure that 
maintaining the out-of-tree patch with a service indicator is a royal 
pain downstream.


>> Of course this would need to be tested since FIPS_INTERNAL was
>> introduced for something else but I see no reason why it can't
>> be used for gcm too.
>>
>> Cheers,
