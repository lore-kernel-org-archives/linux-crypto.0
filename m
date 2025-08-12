Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6A92ECD18
	for <linux-crypto@vger.kernel.org>; Tue, 12 Aug 2025 10:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754996334; cv=none; b=sjebxsskiz4VncsBIJHlVSlO0xqvcHNoiEGghoA5ctrztTGNG/60bza6T9gi+1itJBJKDBFcWxZBiNfFcJSir682ojEoyg3xvdNx2xV6qSPM/+OcsgIHe4a0HTsBmJhEAoX2HawqAayZ71tZNv05xT58q8yQwgWia++RdVK0v4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754996334; c=relaxed/simple;
	bh=fssQde/Sg8azgjf1FtigOZjekJrxBQbwIuZUbk7COJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gJoBjdHDPTIZf2XsWZXG0hY+uEb6hghZC3uYf9o8ZvwDGAtXijMbWum9xLOkdygkOztNtQLdpf0RVjA+Ji9ynDtwgUHMH0N5XCOxpDVAcICau/9+08hj0yZ1ffuvYfbrLcfKV6wLbtG/QFKjMw0V9+5gB4YPUy69pdMwk1g3e4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SThOqS/H; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SThOqS/H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754996331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D9uA+Q/KvY4vhq9ltJK62pRXDrRMxTY6bCYM1WQ37m8=;
	b=SThOqS/H2RVeJnumntiHtLnl6/0eqctuK0ddt1YQdbrpZhLpooQM7wdhtM/z6z+UoIcyxF
	UUp969/e6elEjooqjh4s4nWinTUzM2ioI7rqcH8yNCHaD3guIB8eXGYZ8WKC1wCyWZPTlN
	C3K6ViM/Qwhzzc8dapqp/xKxxE4/5ko=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-219-wnvhGjpROOWxUGoM5kXWZg-1; Tue, 12 Aug 2025 06:58:49 -0400
X-MC-Unique: wnvhGjpROOWxUGoM5kXWZg-1
X-Mimecast-MFC-AGG-ID: wnvhGjpROOWxUGoM5kXWZg_1754996324
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7e69e201c51so1214238585a.1
        for <linux-crypto@vger.kernel.org>; Tue, 12 Aug 2025 03:58:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754996324; x=1755601124;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D9uA+Q/KvY4vhq9ltJK62pRXDrRMxTY6bCYM1WQ37m8=;
        b=ZDCV4kXNr1/t7PyLG7DPs7yw/rMYweVYxaiLzpOpwCD4W2a7SBfbXUpfbodTcFPfCW
         bYaSRiDw1ZJsvo0sAQ2ed6/HAGjloNAJj38tOMDSXCyQOPnkx6I0WAoSVjavvNbvAxtH
         lqjjFDoxt446CA6lJqF3sC3D6D9oLTGybeBw9fq5aVAuSLMxaAmV+6NlnTmqRVEMsa3x
         rWgbIApMQctvNY6w6Lb8p78CM+94gfPICV3GvE4k3lMy2uBBB9d8foy98Yk+IzAfpyXT
         DXuvewrhttBhYVc3lslQD1Rmaz2PJDfv6BnjnUp107UBQnOBtT43Cko8UcKcfjqFGJn6
         CVIg==
X-Gm-Message-State: AOJu0YwkQtm9u4pTLiuvBxQBzKZmoUbl82zGbs93MiTUogdV9EepB9Rh
	CzkngA7X7orY/qxO10waxOKcVdPqIUXy6afqTXSNVHcKlY9ozbaMDBgQRSUP6M4juyS9xntJc6M
	Fo1gk99xq0neB6oPPY7vIJaZG3wyzxGjkDYbLZybrUR6odb88bZuGVEvzjBo+mj/c/A==
X-Gm-Gg: ASbGnctJDeEbEP+lsWqSubvLW5OFp4VDkRA3uYL3k/GP6NFY1L22yMjywUzDBID+asz
	+/MqLAEhEjTXr5CXhJER+Tlr5wpZNswcmvvKKvrYCvA0SE+lGPSrpQnJ+Fq5qBN8NzrLFjEvmf/
	yIVH3w0NkllX+pxqtcz0DZ48ebLGMXcTi333kKpCAOc1mOKi1kPS8Gyk4GXEeEItvZxSonS9yR5
	ToJWG+2X7rSwh2hdZQZ7796mViRzycnu2PERH99LxaIdT2KSvJ9mQgtWsp5vhZ1x6wgDbeCl0QK
	e6jh1juvfa2J1vBPcCHTqapP5A45xSVOs8zaEW2qDYA=
X-Received: by 2002:a05:620a:3b87:b0:7e8:3430:dd31 with SMTP id af79cd13be357-7e8588f3dc8mr382667785a.59.1754996324273;
        Tue, 12 Aug 2025 03:58:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQ2Kb71F1OYz0n6ht6HDmFdodCHOGsbxlm/5LmCLfWhlsHczToyr25YdAyLGhBuyVuu2zDRg==
X-Received: by 2002:a05:620a:3b87:b0:7e8:3430:dd31 with SMTP id af79cd13be357-7e8588f3dc8mr382663785a.59.1754996323415;
        Tue, 12 Aug 2025 03:58:43 -0700 (PDT)
Received: from [192.168.0.115] ([212.105.149.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e7f79b02bbsm1380966185a.27.2025.08.12.03.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Aug 2025 03:58:43 -0700 (PDT)
Message-ID: <167af41d-5d9e-4526-bdc5-0806a4f3cf36@redhat.com>
Date: Tue, 12 Aug 2025 12:58:39 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 1/2] sctp: Use HMAC-SHA1 and HMAC-SHA256 library
 for chunk authentication
To: Eric Biggers <ebiggers@kernel.org>, linux-sctp@vger.kernel.org,
 netdev@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-crypto@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20250811193741.412592-1-ebiggers@kernel.org>
 <20250811193741.412592-2-ebiggers@kernel.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250811193741.412592-2-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/11/25 9:37 PM, Eric Biggers wrote:
> diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
> index 24d5a35ce894a..192027555b4d8 100644
> --- a/net/sctp/Kconfig
> +++ b/net/sctp/Kconfig
> @@ -5,13 +5,12 @@
>  
>  menuconfig IP_SCTP
>  	tristate "The SCTP Protocol"
>  	depends on INET
>  	depends on IPV6 || IPV6=n
> -	select CRYPTO
> -	select CRYPTO_HMAC
> -	select CRYPTO_SHA1
> +	select CRYPTO_LIB_SHA1
> +	select CRYPTO_LIB_SHA256
>  	select NET_CRC32C
>  	select NET_UDP_TUNNEL
>  	help
>  	  Stream Control Transmission Protocol
>  

As pinned-out by Florian, the above breaks a few selftests:

https://lore.kernel.org/netdev/aJsaylkoOto0UsTL@strlen.de/T/#m68ce5625633ce065e73cee9e2c13e40772f499c2

could you please add a prereq patch adjusting the self-tests config?

Thanks!

Paolo

