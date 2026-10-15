Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC1E516147
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 09:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792058194; cv=none; b=UV7WMunLWl4suXPYNalGmKaXZR7DIGUendxiuELzKPIKxiFItV3ZZZzuC8z49omtYouvQ/4HYsYvZ62Op/lTPbQZGzRvWMGlXZMZfflYgkoYOxCYTF0FemyE5uikl7CFSUlM2REFQUUSiX15sOLIJXFE62RyG3fVOrKz7r6rfiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792058194; c=relaxed/simple;
	bh=DWIMKVrAYs5zNnIR24+WWi7oGmWpoE9sIaTVYQD9vn4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FkLhEJAmMW/4U9NVoItxbtxcahcYwav56ut4y52bXFLvbKF8N7e/4ykHiPulb8+sfeomGP4sawW/BtG6A1DvuhgDks7lEvCszU0Gz12tNf3XaV0aO1nQlc+6qt/Yxx8sexRYkrCD34PJFpDlmByEYeRqjmkQOoOjWxqDAKSpxsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tqub//VI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=B5dEG45s; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tqub//VI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="B5dEG45s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792058192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ua9eSzHZOFxfaWBNPL8c+LbJ3qUhPWgj/6uxdqb4+ew=;
	b=Tqub//VIS87tIZo5btROHm3al7VJTlYZ/zAEYUQGuCDLvCxASY05g9loa8tMq+C7AbpUKJ
	A78uwvKpkOZyvMUPxOM7qCj0gfGGapT9PdV4kisAEBBxhDzH2qWCAtCbKkhH2imgNcPhWb
	ZinSMKXHA5uMQNsDoS48CnttpKVfP4o=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-GYD-fsn8MH-YCy-4CFfglw-1; Thu, 15 Oct 2026 09:56:25 +0000
X-MC-Unique: GYD-fsn8MH-YCy-4CFfglw-1
X-Mimecast-MFC-AGG-ID: GYD-fsn8MH-YCy-4CFfglw_1792058184
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-486f9d150c3so3193326f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 02:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792058184; x=1792662984; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ua9eSzHZOFxfaWBNPL8c+LbJ3qUhPWgj/6uxdqb4+ew=;
        b=B5dEG45sYfg72NyeRdpIM9IJ1xh+IfXt2fYYBbHkjKYx9/xqgYnTb4S+lKJ9K5Yp0Q
         R1FAcY18tr1oAND5BB2/mCuds97sRdnb1gyrSvGZH8/3lJm1y/fUDITUSOLFZLH/q0Ov
         y4lbRB2ttEBKGQPjuf06ab9eIARcw6XjbSe4rcH6Hb1W/H870QeysSQG60rVKw0nng1b
         I/oc+CI6LHYWyFlLx6JiDDs+aB/+ztwUTy43AadF7XcECvch46lMNUaG+zv55V8Ybyv/
         w2zAq6Z8MtgLirnKyPNb6OyLyJ3Cjkn0vIcXGivM4oDIFaADvW8IwW4VvprvBkU1up1j
         VWAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792058184; x=1792662984;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ua9eSzHZOFxfaWBNPL8c+LbJ3qUhPWgj/6uxdqb4+ew=;
        b=TdrA46Qw6BqnM3SYw/JGyK0E077TnbpTPCPPmg3BsJNBFNYuH7Sn4I5sPqc/MRJNoX
         50Zo5g7qrxTvfNe1Yvlor62tE1lekJhff0RI3Uf4V5GrbYGUy6YO5lVCHDfVsi+NIaN9
         qgFAWVBb+mOblmO4kpSvivx4eepLs10eAdD3KVy3EEbqknozK0fI+DZ8q7tn6ZzKzWKs
         fBv+a2/CzxisW7y+WDLJt67fN1BgFj7M87N57IzWFA57gZCJ1H/wKPU+DKC8nzXfWZsl
         XXqsK6z2dzbhaAxC+fFfv3L+qeQCOjWOc6v0wPM1wNUpCOW3ja090AgsZICnhPyyqQr5
         vmEw==
X-Forwarded-Encrypted: i=1; AKwUvBz/O1FeqP2rjabp6YufQDHzSpref8przAhl9N4YVZRTWbkb1dN7LzKXCFhL1IgB0bAYduyuJ13SZ0Ki3XI=@vger.kernel.org
X-Gm-Message-State: AFq9FYIoE/ELkvlX27NbiVlCKmlLIrqRDh9U5YEIt1B+QghlHePcoxT4
	JsJhOSameQKQtxI+GvKvncfN2GxWOxkwCgOmeFvaMAh41Wg/6DzMq+EG6ucQ0tc7DK8Z9WqMHqd
	PBuzRFA98CxWw6QLYB1uwOeCfb6VRM3H/R7BDj6Iw4YNCbH1x8Dy/D+31BUZvMXHhiQ==
X-Gm-Gg: AYBFou0kWhzZe8S0mU0ws6Y6mdUi8BPwxJphiCKqQT/wiYch70n5K0RidJkoCcecNZl
	P/kB9LW4EH0DjCJLZnVjCHY9O0KEZT7jKcqt6UfyQy5IcsF2gTMX9HrJs67TcyjIx95ani8TyqY
	8aphJVxO8h5ygi9YTyDA2XCBJPGXpL755Wu7vdR3Qvs+TczyoM4wyeL8BFw/WMi1lrDlXnEx1sp
	fBtTzio/YlPfqcAy713Dfhvd+qYgIb7PLB0WMZPh4U9rK7EBgDfEI3fzsqnkEOBAOLuW1tkE6yE
	tniGde74x0/iuhImW+Ky1baE2b1GLXIn3zogIJiLVRb7ttWEJGYCrWMHM8nl6wj8J0u2Phgt1A=
	=
X-Received: by 2002:a05:6000:2212:b0:48c:5cf9:88d6 with SMTP id ffacd0b85a97d-48dba7bea17mr35259093f8f.2.1792058183884;
        Thu, 15 Oct 2026 02:56:23 -0700 (PDT)
X-Received: by 2002:a05:6000:2212:b0:48c:5cf9:88d6 with SMTP id ffacd0b85a97d-48dba7bea17mr35259003f8f.2.1792058182427;
        Thu, 15 Oct 2026 02:56:22 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.114.244])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48df5c3b89csm2222910f8f.23.2026.10.15.02.56.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 02:56:21 -0700 (PDT)
Message-ID: <1de03136-058a-4edc-8379-bc2a14632c28@redhat.com>
Date: Thu, 15 Oct 2026 11:56:19 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH] hwrng: cctrng - Discard
 pm_runtime_put_autosuspend() return value
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Brian Norris <briannorris@chromium.org>
References: <atCau3kHbzUefyMA@gondor.apana.org.au>
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
In-Reply-To: <atCau3kHbzUefyMA@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/10/2026 11.19, Herbert Xu wrote:
> From: Brian Norris <briannorris@chromium.org>
> 
> Printing an error message on pm_runtime_put_autosuspend() returning a
> non-zero value is not particularly useful.
> 
> Returning an error code from pm_runtime_put_autosuspend() merely means
> that it has not queued up a timer or work item to check whether or not
> the device can be suspended and there are many perfectly valid
> situations in which that can happen, like after writing "on" to the
> device's runtime PM "control" attribute in sysfs for one example.
> 
> Accordingly, update cc_trng_pm_put_suspend() to simply discard the
> return value of pm_runtime_put_autosuspend().
> 
> This will facilitate a planned change of the
> pm_runtime_put_autosuspend() return type to void in the future, similar
> to commit 3afd8df02433 ("PM: runtime: Change pm_runtime_put() return
> type to void").
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> 
>   drivers/char/hw_random/cctrng.c | 6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
> index a6925211c3b5..7e1e1a7844b0 100644
> --- a/drivers/char/hw_random/cctrng.c
> +++ b/drivers/char/hw_random/cctrng.c
> @@ -96,11 +96,7 @@ static int cc_trng_pm_get(struct device *dev)
>   
>   static void cc_trng_pm_put_suspend(struct device *dev)
>   {
> -	int rc = 0;
> -
> -	rc = pm_runtime_put_autosuspend(dev);
> -	if (rc)
> -		dev_err(dev, "pm_runtime_put_autosuspend returned %x\n", rc);
> +	pm_runtime_put_autosuspend(dev);
>   }
>   
>   static int cc_trng_pm_init(struct cctrng_drvdata *drvdata)

Reviewed-by: Thomas Huth <thuth@redhat.com>

