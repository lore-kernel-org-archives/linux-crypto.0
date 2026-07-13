Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AB9381E86
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 06:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783924596; cv=none; b=J+NgViuX/PlvXl8IY4VnPtRR4HjiKNZ/kxotxkuo/tUHTWu7iZYmZ/7j66tQXXiGf/gOOML1NbrAzaHlB8uA33NE/4J6psk0Alvx8kQlWM2kgdzMUTNyN8U3ES7TJNlEY7izZ6UJNEopO2sYjaa3arVDd5GYtxu7f752WZgTPNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783924596; c=relaxed/simple;
	bh=Vc4u4HRzID6Fv2WL6ZDfoR80p9pWUurSOy7bn8WXlmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tpCHCIfbPWoo+UMU6cI2P++mSyO+MC/p5y40Nc61ZV7G7mmWdyTA/5aFfSUGCDfeDmseCANm5IxsyMXItiX55Sr48iNLef681dwYluDdvrGYaA3o0ITZ21AYrc8QpCU0FY9TR4zXTTagYThZq/I0fIbASlEN4H/Z6gyIU4wjLac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D8X4t8j7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DQgKZSWL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D8X4t8j7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DQgKZSWL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783924594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K1nC1RCZXY372njdd6nbwpD+24kS6cgV1fUa231Xig0=;
	b=D8X4t8j7QC9DN1w4LXfFuGncp780v0dML6jdSLSdt9UfmebVF09ZJybqMtxmnQMS1z0Srk
	vqrLc1tb31zKfvIuZZ676CMuktfoZJDIPQrqzaULFc+wBijaGcAyXAo6anxNws6B8PFrE+
	gXjJBY//sUAOQJQCUdnfbD/BXtyIPYo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-599-Z2aHahsoPEaRdymvBeCDCA-1; Mon, 13 Jul 2026 02:36:32 -0400
X-MC-Unique: Z2aHahsoPEaRdymvBeCDCA-1
X-Mimecast-MFC-AGG-ID: Z2aHahsoPEaRdymvBeCDCA_1783924591
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-475de65009dso2498711f8f.0
        for <linux-crypto@vger.kernel.org>; Sun, 12 Jul 2026 23:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783924591; x=1784529391; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K1nC1RCZXY372njdd6nbwpD+24kS6cgV1fUa231Xig0=;
        b=DQgKZSWLgjF0FXWAGjuHGyOVtaTDLTDl6uEViDeH4E0gL3V9IXv/hLeQrVisuGkoeG
         m8zYa/81PePPbM8Fcooi9jC+Fg7Eimfm7gIdhTeWKAKTxWorufqoi6j5KJATAe1VdcmA
         FMcpzfhsktO6UtArvW15SymixQhgnZneUxh74oEP7+OpocOT5E+aA35U2t+oTwL08xBf
         EePfJTdO6dz5Q431Ae0RFNc4bYZB3qkamISd87DfEqgRG7SJDZ4zWWXWQrAAJyGlrpyJ
         j5N+F3n5ZTaJh/EEFiDPy4d40cyh5RNFhDpTnz6nkRwqXT28O3ua+ZV0/qBFetDxk9X1
         C8SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783924591; x=1784529391;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K1nC1RCZXY372njdd6nbwpD+24kS6cgV1fUa231Xig0=;
        b=bF+kEka75ndp1ZhwaTQPxDc677xUyRZJ6JSsbdJ01+BpUPzMqSRj7lF1v6lw2ROEdI
         1kg3SJPOOgHN5bDGkimWjRpXGrdRQy2I+v9sw44PW2CKLa+GBH51MIvzXwxTvbjnq2+E
         4chVtlQd5WMT9Vr3+86CR5bBlgiYAbVx9gMRUPndwLttB293TAvrrhvx6KMF0xnpFflv
         yzOluccHWN1AUJBV5hgRrrAx3lvunGfY8cS6jJps0qQB5bKHgJ5SwzC+0XhHXA3TiadV
         SDKNbPUHNlwL/V1xSNBeJz2gEofSlTCATscmvS3C8jSPQY4dNDx254uMkITHivynCr3F
         gb9g==
X-Forwarded-Encrypted: i=1; AHgh+RrCgo84fLCQH+23u/wz9NG79769ZuQcTx4v37NI/hRLxd3QQbUlxoJsF0d9snqjtc4HQI8m7jccDV0rvlI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxH5GyO+8qQr5mH2TVECpWn8BMMqyuwj9rkHS1S9F4SI6kzfFBv
	E1MW7JtYzAPUBCM+isoUTvC9NRqalYqPFnD0A4Y4LnI0b4sKuzQhmPQSqsRltzQEfPlUTAt0TO0
	2A9luCQiz3kvML7k1PexxnLNWKl8CdaJ8eKLHLJLsGlLXcjBtpR4l8aeUV6BE9she6w==
X-Gm-Gg: AfdE7cnmXKNWHQ4CDuke2DAhJ2eMrswMUkgwVPBcSviTpc5idnoEC1S8i1+5uI+bnyD
	N4S9CALLt0oXisI+KtN8QLfhnsnJQ2XieN11Jkw42AdW0jYhomF3LmB3HDOzj9sW1oFMHBYU5+K
	WTcXOH0QQTG3195BYh7oQXydVZo2FbtMvlx/fqZNCjuB+LSl3jUkIYLFrWANkBVT/z/yGKcI8UK
	iIEuTUEvbD61eMpwa1Ia78+ROgym0oVhVaYDVrWCABnCxlMrorlW/deKU4cHJmu9niW+HYNSXSK
	WlE8SAQ9rny1z4/ehkZQz1om7AhJTFdIJDrMp2FdHUOQjyy4AOLFvw/rThaX9w+rBamlT/EV8Eb
	N4Q4tu7s1
X-Received: by 2002:a05:600c:a14:b0:493:bb29:af40 with SMTP id 5b1f17b1804b1-493f87e6c28mr82429995e9.14.1783924590849;
        Sun, 12 Jul 2026 23:36:30 -0700 (PDT)
X-Received: by 2002:a05:600c:a14:b0:493:bb29:af40 with SMTP id 5b1f17b1804b1-493f87e6c28mr82429685e9.14.1783924590408;
        Sun, 12 Jul 2026 23:36:30 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.114.244])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493f2dad65fsm171802045e9.1.2026.07.12.23.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2026 23:36:28 -0700 (PDT)
Message-ID: <ab58f16b-f2b8-4d37-9db7-30c2482c4088@redhat.com>
Date: Mon, 13 Jul 2026 08:36:27 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: pcrypt - Remove pcrypt
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Steffen Klassert <steffen.klassert@secunet.com>
References: <20260713032600.44355-1-ebiggers@kernel.org>
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
In-Reply-To: <20260713032600.44355-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13/07/2026 05.26, Eric Biggers wrote:
> pcrypt was originally intended to improve IPsec performance.  However,
> it's no longer useful for that.  Reports from the rare cases that anyone
> has actually tried to use it over the years indicate that it actually
> reduces IPsec performance, e.g.:
> 
> * https://github.com/libreswan/libreswan/wiki/Internals:-Cryptographic-Acceleration#obsoleted-ipsec-accelerations
> * https://users.strongswan.narkive.com/liqTaTq8/strongswan-problem-with-pcrypt
> * https://unix.stackexchange.com/questions/594336/ipsec-multithreading-via-pcrypt-worse-than-single-thread
> 
> It's also undocumented and quite difficult to actually use.  Its design
> is also broken, in that any unprivileged program can enable pcrypt
> systemwide at any time (by instantiating it using AF_ALG).
> 
> Meanwhile, pcrypt has been a regular source of bugs, including at least
> four that have received CVEs.
> 
> Let's just remove it.  No one seems to care about it anymore other than
> people looking for vulnerabilities.
> 
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting cryptodev/master
> 
>   Documentation/core-api/padata.rst           |   6 +-
>   MAINTAINERS                                 |   7 -
>   arch/loongarch/configs/loongson32_defconfig |   1 -
>   arch/loongarch/configs/loongson64_defconfig |   1 -
>   arch/s390/configs/debug_defconfig           |   1 -
>   arch/s390/configs/defconfig                 |   1 -
>   crypto/Kconfig                              |  10 -
>   crypto/Makefile                             |   1 -
>   crypto/pcrypt.c                             | 394 --------------------
>   include/crypto/pcrypt.h                     |  39 --
>   tools/crypto/tcrypt/tcrypt_speed_compare.py |   7 +-
>   11 files changed, 5 insertions(+), 463 deletions(-)
>   delete mode 100644 crypto/pcrypt.c
>   delete mode 100644 include/crypto/pcrypt.h

Thanks for the patch, I think it's a good idea!

> diff --git a/Documentation/core-api/padata.rst b/Documentation/core-api/padata.rst
> index 05b73c6c105f..b50df9768a5d 100644
> --- a/Documentation/core-api/padata.rst
> +++ b/Documentation/core-api/padata.rst
> @@ -55,9 +55,9 @@ processors are allowed to be used as the serialization callback processor.
>   cpumask specifies the new cpumask to use.
>   
>   There may be sysfs files for an instance's cpumasks.  For example, pcrypt's
> -live in /sys/kernel/pcrypt/<instance-name>.  Within an instance's directory
> -there are two files, parallel_cpumask and serial_cpumask, and either cpumask
> -may be changed by echoing a bitmask into the file, for example::
> +used to live in /sys/kernel/pcrypt/<instance-name>.  Within an instance's
> +directory there are two files, parallel_cpumask and serial_cpumask, and either
> +cpumask may be changed by echoing a bitmask into the file, for example::
>   
>       echo f > /sys/kernel/pcrypt/pencrypt/parallel_cpumask
I'd rather not keep examples for a non-existing sysfs entry around. Could 
you maybe change it to use e.g. /sys/devices/virtual/workqueue/cpumask instead?

  Thomas

