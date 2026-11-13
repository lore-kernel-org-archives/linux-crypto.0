Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794568854;
	b=qAAKLyI/O7x8IOb2J/5mpcobc8tcR8JEcGmHxKK/rpN244010JnbecNFpRKjq7zqWJgA
	 TojZHxhuv+vrurtFNDS3gFDqxNEDgVqEzW41brj0Sm+TMxxPKWPwLFYLHO61VY4COy0s1
	 dq503vGxsnFC6K6dIdrbdia4xw2FB4lgk6Guzw0omLIMx+T+x75aKHTS4Jz9YDx1p2Ed7
	 jzAEjRdZJ/W1I1UcY9K/MJUkXegmjeGbixBoJfJG6F6FUfbZsCm4JqrQ1cYGtntCeNO6K
	 gyuUyem0YZl6J21TV1HSXsrpPkMggyPaGeEa8EuNNjVOu1VWylssBcUwuLfW8Zi277Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794568854;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=z45whPdKr9S3p7TkkwcoWCQyt+iMm3cvuo8IR0skgLI=;
	b=bdNSuU6U+pnCxfjeVv1skSh4F0P7sRk0hGoneBBbpPxiOH2IyOpTITqvuuvdMJQpUpXn
	 UpI6lTWARzGMIXydMcnpnN2uI1XhDAnZFTanPkQgjIqXWRohNwEtymIxbtIEZuwM7kRg2
	 4carypq372JtWOgrKrcYEoxxJ7QKe0gvkOyZwaqvtNsOTBJzhJfLdFa4FxAJZGbBBB9oa
	 Xd5LdTDQ8cTKJSdvfd1hpsGMNwpS+QB1+m/tmprBfvi9pLGsmtiGwdGrteuB7aZZwUKCQ
	 tMDJHUHZdUgMaef6sC7GYnujYKyGXXgXcbCyyZefjZjvYTsYiI3eevoA20Q7IlG8OLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hk8IIM04;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=cvZdc3IP;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88976606A32E
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 11:20:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88976606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hk8IIM04;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=cvZdc3IP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794568852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=z45whPdKr9S3p7TkkwcoWCQyt+iMm3cvuo8IR0skgLI=;
	b=hk8IIM04ucOU4JF75MUhd1qlw1IRA533W2NbsWskREOSXmHhytghNFxKETmbdEBys0s/Uy
	zD4HmcggoOPNzrvR+QWMWT1JRlU6rYzJDQfAJmRwpKxXz+71kR03syo30Vn8cTrPrVF0Ao
	ZdIJDga5zBvP9Uq1h2IZ4sln6LCnBzg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-244-uhpsB9rjMYeQNHXVelrEiQ-1; Fri, 13 Nov 2026 06:20:51 -0500
X-MC-Unique: uhpsB9rjMYeQNHXVelrEiQ-1
X-Mimecast-MFC-AGG-ID: uhpsB9rjMYeQNHXVelrEiQ_1794568850
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4ba078abd78so5706775e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 03:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794568850; x=1795173650; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z45whPdKr9S3p7TkkwcoWCQyt+iMm3cvuo8IR0skgLI=;
        b=cvZdc3IPsegK3KK4I/DGt/1VpNhGyPFaagHX7F1DAMiKuC7nYz/DRZvFqV4xcXexQ0
         XdwY430I6BDbjdRRWmKhMxa4GUv+JbVcU+YX5KBz9ONk9+3a0vlBlOruho1iBfznaSE4
         mmtPnmPVlaM6Un23h1W+9ebIcXvq9SncM8rKwMcuivs5gjWXe07Bu/PqfC1PCMf5z4gs
         NrB+Pd2YOj/T+L/gS1yGYiPZmXWIdPzs6DePCfUJsaIK6XNEWPIdfDTFl0kv435KjCIR
         yJj7U5MKOwMtHCtrEHkt5oQVQOY4svkFsVmME9yRI1hJXNPciT4m2IZHsJnLpoPcncTw
         tRUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794568850; x=1795173650;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z45whPdKr9S3p7TkkwcoWCQyt+iMm3cvuo8IR0skgLI=;
        b=OgzpB//FwOxOMHqXTGA/t8joSDFmLidt/roKvg+Zl+v354+PSLtI8OtmOUElPxpysa
         ZEyfdKV6+5P1rLf4lZU8dTSUOrQTrK4YAPH2kywREincMh9tvvpQTn4+fxal+8d/OZhO
         GGhrD/dN7Abw91l/c8dqJd8rKaQGLIoiWwe9HqDpfW4DP3SnnUVKYQ00U2rZ8on6X0Go
         XOPUAmZE1lobHn7Y9w3nMemLDgUuldfpvEUURGPFpa2iwke4Ifn22E2+X4C/HaDlbl8d
         0K+N3fdTkApUsjXGeDNAAAN+eAcn5RyI9NO47PwkcK6mHiY9lXR26/VzzeceMiVgyeQ6
         Q4lg==
X-Gm-Message-State: APuU4Z9w5F5MxgEa2jELK7wG4oSXztXUoyKF0OINJEjvElJLdVwdTsyu
	h6gs9YciuVpoS4qf1KvXfdE0oPv8AlU/S1f2i2/PfybNAHBS62g9a9TZ1f/WQC6piA3f1PzeWdt
	1Lc+xeQjVNintuoHgTQyxqOFg4ca2Xr8M9a0zqsTUm61c55xfJwjvIcTDvC/e05QNQw==
X-Gm-Gg: AYBFou0Js/Ut5eokUFMjwfO1x5yFBmzQf11DVMIIIC7yTuuEkZ3CfisgaXVZBgFEl/d
	aB0E1AOu94PWlVN4QzTUtc5Ejp9kNdB/Sxd2XN+hzfL9JNvdbai8mprEkcQD9MBaRKg0Ysu6+lA
	a1BIM7l4TQYJpXqWYw/hIuLxulit0A7++4/O6uhj0qGMZHFQoW+jhyw/YuFEhSv5IZevY4Xlx7y
	4+oNKMd6eiI6oDJ3eZGwsyllUD37odg/laauKLZpcVk5m8Qm0LlcB8a6F4eyjyS8UvmKegWAEJ3
	gbe4QfeLILwR37ah3XY7R5rmIUMYj1HzaLV9DV5q58Lwje+0LIYAnMvJ4JBjdBpzo5+4hxJOUwq
	7A7g+C+WGsvAIj2B+MDd/hIuZp+uU8LqdDHEIQ/5n9FFH
X-Received: by 2002:a05:6000:2886:b0:490:6e0f:a02e with SMTP id ffacd0b85a97d-49c70b05145mr5376565f8f.17.1794568850065;
        Fri, 13 Nov 2026 03:20:50 -0800 (PST)
X-Received: by 2002:a05:6000:2886:b0:490:6e0f:a02e with SMTP id ffacd0b85a97d-49c70b05145mr5376507f8f.17.1794568849570;
        Fri, 13 Nov 2026 03:20:49 -0800 (PST)
Received: from [192.168.0.9] ([47.64.115.75])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c609c602dsm4473677f8f.46.2026.11.13.03.20.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 03:20:48 -0800 (PST)
Message-ID: <545910af-9ff4-4fcc-92bb-43a56f88753e@redhat.com>
Date: Fri, 13 Nov 2026 12:20:47 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qat - clear fw_loader pointer on adf_ae_init()
 failure
To: Ahsan Atta <ahsan.atta@intel.com>, herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>
References: <20261103100126.534424-1-ahsan.atta@intel.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20261103100126.534424-1-ahsan.atta@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 03.11.26 um 11:01 schrieb Ahsan Atta:
> adf_ae_init() stores the newly allocated loader data in
> accel_dev->fw_loader before calling qat_hal_init(), as the latter
> publishes the HAL handle through that pointer. If either
> qat_hal_init() or adf_ae_reset() fails, the error paths free the
> allocation but leave accel_dev->fw_loader pointing at freed memory,
> so the device is left holding a dangling pointer.
> 
> No code path dereferences that stale pointer today. This is therefore
> a robustness improvement with no observable failure behind it, hence
> no Fixes tag.
> 
> Clear accel_dev->fw_loader when the allocation is released, and fold
> the duplicated error handling into a cascading goto chain. Report the
> error returned by the callee rather than a generic -EFAULT;
> adf_dev_init() still maps any failure to -EFAULT, so this is a
> readability improvement and not a functional change.

The -EFAULT in adf_dev_init() should likely also go away: EFAULT means "Bad 
address", i.e. a page could not be accessed. Thus it's likely the wrong 
error code for most cases there.>
> Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>   .../intel/qat/qat_common/adf_accel_engine.c   | 21 ++++++++++++-------
>   1 file changed, 14 insertions(+), 7 deletions(-)
Anyway, this patch is already a proper step into the right direction, so:

Reviewed-by: Thomas Huth <thuth@redhat.com>

