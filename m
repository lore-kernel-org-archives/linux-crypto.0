Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D3D29B200
	for <linux-crypto@vger.kernel.org>; Wed,  9 Sep 2026 14:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964625; cv=none; b=VZISUhmisUj2/ZsPnJDzAZ/HmxLinFuMpCIgvI5p4G9owcY+SC0BbiPBnw84bTZDw7hfO2lbBhcbr1pdzcwADwTIpbpXOaa76Fj59WUFadEc8793xMXOh8iPjV0pi5YJ8+dfo75wUUTjFnVaekyOC+FrGuFtYpD6ppXqBtmKBok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964625; c=relaxed/simple;
	bh=qgh8cq+GBXevS49T3N8s10vizXRzbGlS3p2jOaxKhLk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kq32gKoUIe9/nfmUMmLoD2PcqTldZbASF4ORuwFcQw/fGKktWlqAyBn+k8YClKsMt5OKniJ3/NZBJczUcCHfNkN1H4kJ0ckMubu1BDnJd+gj9/peZGBI9WULjDpcsNYSRkjymvdQmDelmsrljrCt6sWzonffWa1HycS4IFg71Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UjmRnded; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JQ54Pu1a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UjmRnded";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JQ54Pu1a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788964622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6z0vb7jFmVZwRL61UmhAH1J2R42fJJdVb15beRTLwfM=;
	b=UjmRnded83ikLDdM0IDvfjIoNCOC/t/pvTR1SCv2DbGQ4wSJtT7av/9cONQjPyXkxbcXjY
	x18/uNhZSDnafsHydzCwjFVDf7j5R5nwjvuTAXfbRieiozCdJIjEEWCeV+xawAKS4WRU8j
	pFN9jkdIJv2XcpHd6wAU2pO+kLcWR1Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-c9bI3v7pPA2A5vE6RBznzQ-1; Wed, 09 Sep 2026 10:37:01 -0400
X-MC-Unique: c9bI3v7pPA2A5vE6RBznzQ-1
X-Mimecast-MFC-AGG-ID: c9bI3v7pPA2A5vE6RBznzQ_1788964620
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49d0ae342b9so29950005e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 09 Sep 2026 07:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788964620; x=1789569420; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6z0vb7jFmVZwRL61UmhAH1J2R42fJJdVb15beRTLwfM=;
        b=JQ54Pu1azjwXwWxgXxy9A1WDaRR5jYrQ14xO/GE9weOtozXq8jpH7Uf64hF0RZIJUV
         cfBogN/tx2LjBEtak3fe4nsJLOXBJcC9coI0li5q8VNMsCD6CsKDgH8snZy0nMiSx/v0
         Q1cLAoeUrDo2RT/VvYAQEHmNiwdLOyatZnXG6fv/UrIUjDUsEBrvjYS2/v31EyY6Qsjy
         8eibNGNKcZAbWqjrDIEfrY52hVyCtbVe6zPV2fE4BepeeYt4pDO8MoxyoPw9Mc6rM7c3
         zZcLWz4+Su+mir8B428TLHkxls7E9ACYT1Prf4gLOrIvrUUoRGEgwZx3CDpCWe2vpZzY
         +PwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788964620; x=1789569420;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6z0vb7jFmVZwRL61UmhAH1J2R42fJJdVb15beRTLwfM=;
        b=AeZl51mgN3uNwbhmPW/fnbxFGv3KAFSpi2OnWq0EBCP+tR1pGF43nSjqgLDcnE0kQx
         GOLQgsWqTDoWSb1eXJnMeCpxkuROsfgBms1GEjtsyei891fkcvQxNzRQZiis4rBJiLEY
         OaPwOqcIHHvSaHkqvsvuejpCEjlOvQqFHOLBGDJKL9o9PExI5+8jQIlxntzRio3Toeps
         OfyQjwgKfed43XgSY2ydExX5rtVm2k2rS8GO4/DdWRDFTB3jKSHo94nEq1hBB+1FFOHt
         W8prCplq74EmiKp98+hnaDkAxXm6uEWt5XsEXhnHNG2rAWPi9d59UkSXh5N0ZIA5VJV/
         VoDQ==
X-Forwarded-Encrypted: i=1; AKwUvBzhhhHvi5VaL10ssZ51E7LMzNssFzLFpYANdWGeJGYr8bv4E9OXuM7hlM33NeiTOy3v9xC9Wc4tY6Sdh3g=@vger.kernel.org
X-Gm-Message-State: AFuF++kIEulPd0Bx/sO2HIxqboLYknmbtls1/JB4mQCYPwifBOtWZ9EV
	VfEpVBt9caVs/n4LFNL2B+YA2SLaKn+MRzzkTztsNS2yfoQSTX7S8GDYcuv1tVzy4UGJO6E13AC
	rlNMyEBzA+jJQrBkzhUPKPYFaGOZnocwuhavaqx93fRfQiLr0WWSmOBmQkA55fGtM8g==
X-Gm-Gg: AYBFou2mFyRGtW3ni5VRscQLtSf2+3rAOhnDDY9PGdSahPtLITXQIH6s5P0kqF+Qdaq
	8uMY3H9G5sdhXwKj4U+3+iJfESt3Ss7jy5cn9VlWWJtneIyePXrxcfIWyJN0oJhJNsFi4e+A15Q
	nX9s3nABejlRMKmKBwB3OGi4fmHFbCg2Rr84YgEyH9+dVaJUK6emAkYHRQkVquqkW8wyZstfYtv
	Da2Js/IIYavh4gGr1EiN7rRpv10H4MF9OW+N8xc/i0MYu/MTxFV1t+/eRpTUMGhaYeUN5nFkDMK
	LmQEdZoQNGIkycfiBle/aGN2fra6prSBESce9pVuOOedrihRPqIDPrHawZWB0kUJrcYxsop9oQ=
	=
X-Received: by 2002:a05:600c:3588:b0:49c:fc6e:a3d7 with SMTP id 5b1f17b1804b1-49cfc6ea7d5mr340867335e9.22.1788964619768;
        Wed, 09 Sep 2026 07:36:59 -0700 (PDT)
X-Received: by 2002:a05:600c:3588:b0:49c:fc6e:a3d7 with SMTP id 5b1f17b1804b1-49cfc6ea7d5mr340867045e9.22.1788964619344;
        Wed, 09 Sep 2026 07:36:59 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.114.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee80eda4sm559571965e9.15.2026.09.09.07.36.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 07:36:58 -0700 (PDT)
Message-ID: <9926908a-5f08-43ba-99dd-b83c7067d52b@redhat.com>
Date: Wed, 9 Sep 2026 16:36:57 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: testmgr - block Crypto API xxhash64 in FIPS mode
To: Joachim Vandersmissen <git@jvdsn.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 linux-crypto@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260303060509.246038-1-git@jvdsn.com>
 <abTuFto8Tc3mhRRe@gondor.apana.org.au>
 <64592fee-1956-4a70-a751-9ac3335cfc27@jvdsn.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 xsFNBFH7eUwBEACzyOXKU+5Pcs6wNpKzrlJwzRl3VGZt95VCdb+FgoU9g11m7FWcOafrVRwU
 yYkTm9+7zBUc0sW5AuPGR/dp3pSLX/yFWsA/UB4nJsHqgDvDU7BImSeiTrnpMOTXb7Arw2a2
 4CflIyFqjCpfDM4MuTmzTjXq4Uov1giGE9X6viNo1pxyEpd7PanlKNnf4PqEQp06X4IgUacW
 tSGj6Gcns1bCuHV8OPWLkf4hkRnu8hdL6i60Yxz4E6TqlrpxsfYwLXgEeswPHOA6Mn4Cso9O
 0lewVYfFfsmokfAVMKWzOl1Sr0KGI5T9CpmRfAiSHpthhHWnECcJFwl72NTi6kUcUzG4se81
 O6n9d/kTj7pzTmBdfwuOZ0YUSqcqs0W+l1NcASSYZQaDoD3/SLk+nqVeCBB4OnYOGhgmIHNW
 0CwMRO/GK+20alxzk//V9GmIM2ACElbfF8+Uug3pqiHkVnKqM7W9/S1NH2qmxB6zMiJUHlTH
 gnVeZX0dgH27mzstcF786uPcdEqS0KJuxh2kk5IvUSL3Qn3ZgmgdxBMyCPciD/1cb7/Ahazr
 3ThHQXSHXkH/aDXdfLsKVuwDzHLVSkdSnZdt5HHh75/NFHxwaTlydgfHmFFwodK8y/TjyiGZ
 zg2Kje38xnz8zKn9iesFBCcONXS7txENTzX0z80WKBhK+XSFJwARAQABzR5UaG9tYXMgSHV0
 aCA8dGh1dGhAcmVkaGF0LmNvbT7CwXgEEwECACIFAlVgX6oCGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAAoJEC7Z13T+cC21EbIP/ii9cvT2HHGbFRl8HqGT6+7Wkb+XLMqJBMAIGiQK
 QIP3xk1HPTsLfVG0ao4hy/oYkGNOP8+ubLnZen6Yq3zAFiMhQ44lvgigDYJo3Ve59gfe99KX
 EbtB+X95ODARkq0McR6OAsPNJ7gpEUzfkQUUJTXRDQXfG/FX303Gvk+YU0spm2tsIKPl6AmV
 1CegDljzjycyfJbk418MQmMu2T82kjrkEofUO2a24ed3VGC0/Uz//XCR2ZTo+vBoBUQl41BD
 eFFtoCSrzo3yPFS+w5fkH9NT8ChdpSlbNS32NhYQhJtr9zjWyFRf0Zk+T/1P7ECn6gTEkp5k
 ofFIA4MFBc/fXbaDRtBmPB0N9pqTFApIUI4vuFPPO0JDrII9dLwZ6lO9EKiwuVlvr1wwzsgq
 zJTPBU3qHaUO4d/8G+gD7AL/6T4zi8Jo/GmjBsnYaTzbm94lf0CjXjsOX3seMhaE6WAZOQQG
 tZHAO1kAPWpaxne+wtgMKthyPLNwelLf+xzGvrIKvLX6QuLoWMnWldu22z2ICVnLQChlR9d6
 WW8QFEpo/FK7omuS8KvvopFcOOdlbFMM8Y/8vBgVMSsK6fsYUhruny/PahprPbYGiNIhKqz7
 UvgyZVl4pBFjTaz/SbimTk210vIlkDyy1WuS8Zsn0htv4+jQPgo9rqFE4mipJjy/iboDzsFN
 BFH7eUwBEAC2nzfUeeI8dv0C4qrfCPze6NkryUflEut9WwHhfXCLjtvCjnoGqFelH/PE9NF4
 4VPSCdvD1SSmFVzu6T9qWdcwMSaC+e7G/z0/AhBfqTeosAF5XvKQlAb9ZPkdDr7YN0a1XDfa
 +NgA+JZB4ROyBZFFAwNHT+HCnyzy0v9Sh3BgJJwfpXHH2l3LfncvV8rgFv0bvdr70U+On2XH
 5bApOyW1WpIG5KPJlDdzcQTyptOJ1dnEHfwnABEfzI3dNf63rlxsGouX/NFRRRNqkdClQR3K
 gCwciaXfZ7ir7fF0u1N2UuLsWA8Ei1JrNypk+MRxhbvdQC4tyZCZ8mVDk+QOK6pyK2f4rMf/
 WmqxNTtAVmNuZIwnJdjRMMSs4W4w6N/bRvpqtykSqx7VXcgqtv6eqoDZrNuhGbekQA0sAnCJ
 VPArerAZGArm63o39me/bRUQeQVSxEBmg66yshF9HkcUPGVeC4B0TPwz+HFcVhheo6hoJjLq
 knFOPLRj+0h+ZL+D0GenyqD3CyuyeTT5dGcNU9qT74bdSr20k/CklvI7S9yoQje8BeQAHtdV
 cvO8XCLrpGuw9SgOS7OP5oI26a0548M4KldAY+kqX6XVphEw3/6U1KTf7WxW5zYLTtadjISB
 X9xsRWSU+Yqs3C7oN5TIPSoj9tXMoxZkCIHWvnqGwZ7JhwARAQABwsFfBBgBAgAJBQJR+3lM
 AhsMAAoJEC7Z13T+cC21hPAQAIsBL9MdGpdEpvXs9CYrBkd6tS9mbaSWj6XBDfA1AEdQkBOn
 ZH1Qt7HJesk+qNSnLv6+jP4VwqK5AFMrKJ6IjE7jqgzGxtcZnvSjeDGPF1h2CKZQPpTw890k
 fy18AvgFHkVk2Oylyexw3aOBsXg6ukN44vIFqPoc+YSU0+0QIdYJp/XFsgWxnFIMYwDpxSHS
 5fdDxUjsk3UBHZx+IhFjs2siVZi5wnHIqM7eK9abr2cK2weInTBwXwqVWjsXZ4tq5+jQrwDK
 cvxIcwXdUTLGxc4/Z/VRH1PZSvfQxdxMGmNTGaXVNfdFZjm4fz0mz+OUi6AHC4CZpwnsliGV
 ODqwX8Y1zic9viSTbKS01ZNp175POyWViUk9qisPZB7ypfSIVSEULrL347qY/hm9ahhqmn17
 Ng255syASv3ehvX7iwWDfzXbA0/TVaqwa1YIkec+/8miicV0zMP9siRcYQkyTqSzaTFBBmqD
 oiT+z+/E59qj/EKfyce3sbC9XLjXv3mHMrq1tKX4G7IJGnS989E/fg6crv6NHae9Ckm7+lSs
 IQu4bBP2GxiRQ+NV3iV/KU3ebMRzqIC//DCOxzQNFNJAKldPe/bKZMCxEqtVoRkuJtNdp/5a
 yXFZ6TfE1hGKrDBYAm4vrnZ4CXFSBDllL59cFFOJCkn4Xboj/aVxxJxF30bn
In-Reply-To: <64592fee-1956-4a70-a751-9ac3335cfc27@jvdsn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 15/03/2026 01.43, Joachim Vandersmissen wrote:
> Hi Herbert,
> 
> I don't think this one can be applied yet since dm-integrity still uses 
> xxhash64 through the crypto API. This would break fips=1 systems that use it.

Out of curiosity: Wouldn't such a system be FIPS-incompliant anyway? If 
xxhash64 isn't FIPS-compliant, nobody should use it for dm-integrity there, 
right? So I doubt that there are any systems out there that use fips=1 and 
use xxhash64 at the same time?

  Thomas

> 
> On 3/14/26 12:11 AM, Herbert Xu wrote:
>> On Tue, Mar 03, 2026 at 12:05:09AM -0600, Joachim Vandersmissen wrote:
>>> xxhash64 is not a cryptographic hash algorithm, but is offered in the
>>> same API (shash) as actual cryptographic hash algorithms such as
>>> SHA-256. The Cryptographic Module Validation Program (CMVP), managing
>>> FIPS certification, believes that this could cause confusion. xxhash64
>>> must therefore be blocked in FIPS mode.
>>>
>>> The only usage of xxhash64 in the kernel is btrfs. Commit fe11ac191ce0
>>> ("btrfs: switch to library APIs for checksums") recently modified the
>>> btrfs code to use the lib/crypto API, avoiding the Kernel Cryptographic
>>> API. Consequently, the removal of xxhash64 from the Crypto API in FIPS
>>> mode should now have no impact on btrfs usage.
>>>
>>> Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
>>> ---
>>>   crypto/testmgr.c | 1 -
>>>   1 file changed, 1 deletion(-)
>> Patch applied.  Thanks.
> 

