Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDB1283C9D
	for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 12:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786453062; cv=none; b=sXaiuDO4RcQ4IGu1FjpV0SwaH8ApJIJZbrSL/w3dTCA8A8BMC8qG9pVqIhqKKHPWZ4Qj/I49Rac/kCh5e4TUIGraB5olRpcVRWk9xy60sHuz4O/rAYFyn6QTDaqBCacRtxZbt7KZoDT71Dp+eDC9lt1to0foMTWvrx8WZVB4oYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786453062; c=relaxed/simple;
	bh=gYdofRMujdzQOFJaSBNLQz1thCmXMhJyHxwSQzIPFr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DWbRjIU5gOE+6o/EH8gon8yGZVbDfma1oPvtVncL6hF6jkTw1ctDtq/fpJH0FoH7RBYPh24xaUW3h1mJEBbgZaBLihw74CAEZf35EvAUzEnBHIvcrg4SrawKBuR2+BEirvvs2oPnPPhjUC9h7XYlGv3hzOGomNdlTLglId/+rSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GO4mSU+F; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AxGd4kHJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GO4mSU+F";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AxGd4kHJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786453060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0frBHjd61EyLYz0mPRsCOHDWT5ZKOwhF/npWzCbt6wI=;
	b=GO4mSU+FP3l0C4xELEtz4rAM/0ohqo/+uWopu/tTdWM77nG4o+rHhpi7yiz0Y4N7skDIb1
	3fjik6wmHncsUy0EYbkFuXDjbhxjZ6gT5QeGSa/1l1pWROA4XZpxGY8+ydm0yyaFRT53hc
	9IaEPiBDKNIl8ItYhhM0e1pBvup5DNI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-T6KLORwUP9eSKDwFC3em2Q-1; Tue, 11 Aug 2026 08:57:33 -0400
X-MC-Unique: T6KLORwUP9eSKDwFC3em2Q-1
X-Mimecast-MFC-AGG-ID: T6KLORwUP9eSKDwFC3em2Q_1786453052
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-47fd4ee0ac0so2368378f8f.2
        for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 05:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786453052; x=1787057852; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0frBHjd61EyLYz0mPRsCOHDWT5ZKOwhF/npWzCbt6wI=;
        b=AxGd4kHJYRjjTPJLLkth7ToNFMT5ZKZJ0Eu6qy8eEvX46afijUXEZAnSKPR9+reldX
         wxwDvlMdaDmLNQxB0lVhchvOb7L8cfeSl1boSkT5VnpDbldoJUZ9uKjqZYnQ5Uh1hZCL
         KkOK0Kv4vDdWZTMNoaWEce005ELoAoAEQ1ZRqG+Grh8VJGNzsbJdgz9BzRFbtSO+z0WP
         mcRM7gTCe8FRoHJLa/UItkwwIbGGNIHh02azI5GAlcFhFHFmjfo7RjEpKsRczQZHiy3Y
         055FAVxJk3Nk3AzQai3pTwYfdwFgAUejayWcYYExY3GkOT6wjytpggqoYnXQrmA51DSc
         qLHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786453052; x=1787057852;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0frBHjd61EyLYz0mPRsCOHDWT5ZKOwhF/npWzCbt6wI=;
        b=Z9hrBO+Tbh357+9SeRGukDlAFmd0x/6AVdhJu1l6gscpK0bkxgMYdDrq8MuIoLYpE6
         nl9rJyTpnmC1bfqMkLDffoC1ZiYxl/dPcxGFM66v4UnFCSp99FOJkDTPG3yYeMigKC8c
         +Si89TSEVPfWJZCxNK9+ntnU/yTSvxswPQk2Eimkz0zA9LkBhbt4PtodbAV0lZ2fh9JE
         IzTIv6hmb5IxLTroSuNrLyHkn3U94Kol2a002cs2k50gG7RFWxKX1tE9khAg5Pj4SxEH
         pmfHPPxstOkszIP6HJNGwGfXDfwNIW0G6veIw6AyME4o+/IEp654zUluAdoUfIqeMAZR
         zffw==
X-Forwarded-Encrypted: i=1; AHgh+Rqcs/T3qkgTOp0HQwKqACrjE6IUPSYQ5kIElQFjca/bJWzLlQfy6YrBQiZZ3tB8l9ibeD2stZ9b93EZ/oc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ2NtJnssR4YAUsiyJVQoloTaDg88bexwL0rsTh5XtXKvA2Y4q
	chOzzP+0V5SewuCiZT2orD4MWnOYWM8cn4zKW/Wg3PNPMu2YbmDTGMpLSdiAZ9AcnUs99B0B92J
	mlBbguXfuT3sUo1cRRae4qOd0yp3q56SRN2X8MV6pm8MmbwqdS9oAp7XTYVlC3faXcg==
X-Gm-Gg: AR+sD12j4H2hMf+DnlOKe4zYU0j0KTFdOhilR55JkK7jUukBHKm8C2m4QTZssrMIPeZ
	sJJdg23ApUlvbHqP0majIdKsj6OOumA8qyqXcMkUxrMutppMgHfUQQcv+dCyhs6LWlqglteQPHB
	CJBNYs30GH2c6ZvH/tPGatw6faE+yKYLcPFARsgM9AmpNJM2mCA5/9W/PUH+AOdafZvLW5K0gJ5
	f6CgnXBVO5nS0ctOBp7YqEOMfBdWSD4rcS/QQGOuGTAdcs6hr4OI/UfcmW1fs1xONVroIFf3Wy1
	LBVjjTm7GHfBbjBNpvx8aR/mmWJJA3hyN9D6bHOuOzCfUlnhHddMf3a1p3FwnNva+7dcXYEK
X-Received: by 2002:a05:6000:4a19:b0:47f:ec8a:214f with SMTP id ffacd0b85a97d-4814adc3281mr5811662f8f.15.1786453051991;
        Tue, 11 Aug 2026 05:57:31 -0700 (PDT)
X-Received: by 2002:a05:6000:4a19:b0:47f:ec8a:214f with SMTP id ffacd0b85a97d-4814adc3281mr5811584f8f.15.1786453051613;
        Tue, 11 Aug 2026 05:57:31 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.114.24])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4814a709361sm4217694f8f.20.2026.08.11.05.57.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 05:57:30 -0700 (PDT)
Message-ID: <e23dc8fd-67c5-4950-a598-13ff50a40d1c@redhat.com>
Date: Tue, 11 Aug 2026 14:57:28 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] smb: clear the aes_cmac_key and aes_cmac_ctx when
 done
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Steve French <sfrench@samba.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Steve French <smfrench@gmail.com>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
References: <20260807125845.1477067-1-thuth@redhat.com>
 <20260807125845.1477067-3-thuth@redhat.com>
 <CAKYAXd_VJH8dFHofy2Jfk2172vDuU+XizXQf06w0oz81F1WDdQ@mail.gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <CAKYAXd_VJH8dFHofy2Jfk2172vDuU+XizXQf06w0oz81F1WDdQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/08/2026 12.31, Namjae Jeon wrote:
>> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
>> index 1143ee52470a7..d23566da2ac81 100644
>> --- a/fs/smb/client/smb2transport.c
>> +++ b/fs/smb/client/smb2transport.c
>> @@ -464,8 +464,8 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
>>          unsigned char smb3_signature[SMB2_CMACAES_SIZE];
>>          struct kvec *iov = rqst->rq_iov;
>>          struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
>> -       struct aes_cmac_key cmac_key;
>> -       struct aes_cmac_ctx cmac_ctx;
>> +       struct aes_cmac_key cmac_key __cleanup(aes_cmac_zeroize_key);
>> +       struct aes_cmac_ctx cmac_ctx __cleanup(aes_cmac_zeroize_ctx);
>>          struct smb_rqst drqst;
>>          u8 key[SMB3_SIGN_KEY_SIZE];
> Shouldn’t we also clear the raw key with memzero_explicit(key,
> sizeof(key)) immediately after aes_cmac_preparekey() ?
> 
>          rc = aes_cmac_preparekey(&cmac_key, key, SMB2_CMACAES_SIZE);
> +        memzero_explicit(key, sizeof(key));
>          if (rc) {
>                  cifs_server_dbg(VFS, "%s: Could not set key for cmac
> aes\n", __func__);
>                  return rc;
>          }
Yes, but I was planning to do all the scrubbing for such other spots in a 
separate patch series (similar to what I've posted for the smb/server code 
already) ... this patch series here focuses on aes_cmac_zeroize_key and 
aes_cmac_zeroize_ctx only. I hope that's ok?

  Thomas

