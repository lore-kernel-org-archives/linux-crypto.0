Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FBC748F
	for <linux-crypto@vger.kernel.org>; Thu, 16 Oct 2025 05:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760590852; cv=none; b=iViL44Jggrz9ZyQQFuh/Z0l8B6qCHAlfHOFYbwzzfG5CEqOkRYM2QeYnQOmuuOG0xXr8MTu7lQjikAzPOQ0KgsC7syTDM1MZrq9LPGNTf07pVoJkQBT/sGDuSXMKyZwMuv41Ucnto5FcXUdUWoPtG5oR5JxofcbuKSSqGzc7Qy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760590852; c=relaxed/simple;
	bh=fAIUKkVGEDMQSw+YMV+ZkW+6CXHd5EzsCC3uoaAr2j4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mgsp9A/tbzIoLz6upoyF1IKR8j/6Mn1OF5kBxqhmIGARA3Su+AJRfNP6oARoNheB+wMHSkpySAidELyUOOj6ezIFwjqzPldL69/oqRrE+7OwMHblYAl0TM9wFuvA/ozDzPXm92K/T2qxLlFE5RUAY+8EhI9YOFXlr1ewu44Vt3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=coly93uD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="coly93uD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060DAC116C6
	for <linux-crypto@vger.kernel.org>; Thu, 16 Oct 2025 05:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760590852;
	bh=fAIUKkVGEDMQSw+YMV+ZkW+6CXHd5EzsCC3uoaAr2j4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=coly93uDHVLDbQlEjrbae+L3DYKTXKidYGXfkKIaK6nfiIm+hVRgDJkG5pxG5cJyA
	 vhMSePLlaLnEXqzUHRKexpIAIIiF6nqsw9Sa5rgs4cnc5r2VufNWiqya1w0xjq8Zmm
	 rphEZrsidSeaIDDH+UzCHFTJxupVr7Zp/C+PZaIoAV4KQcuMtVDPdbqb5/6hqXaYbQ
	 fblo7Ufm94v663yeoAue3lV4SfS/hffJjY3YS9Nq8ree4ydnTxnG4nshyIZSvL3eLV
	 rNA5YKT/AX4vW0wN78SMOP9fHtth4QqhKTue1D3wwqv22WTd0h/hO71o2S+WSsM3K3
	 +qsU0dcNeXGug==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b3f5e0e2bf7so53660566b.3
        for <linux-crypto@vger.kernel.org>; Wed, 15 Oct 2025 22:00:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXLgbec6rV7BZDUNlLP3vEmv0b/6eGk/ds5/OivEG6JOb+Fvbj3vuVAvfNjiKZ90NVTDywMqms+TmYdmcU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0Ds/ODmpwgnCYpYMqawxYGe46YQiAL1gkoaIoO3MdcSiOcBl2
	v4hDtnllR47Rq8rG79UJG0ow4XAPxNCxVSZWX21XrIqYnF2zhhQ3v3XFVqOc51Pw4OKcH74uq7o
	9PE831X15UbIsjQ+sug5QUhpKLAmDhoY=
X-Google-Smtp-Source: AGHT+IEY11X+4xZ+krDfOvm/Ag4wScsRVBM+LmJx/jRuk24Jip+lVkDizfbWe3vuwqsKRk2mlJobKVSQ9YIGtwswU8c=
X-Received: by 2002:a17:907:d06:b0:b0d:416e:2892 with SMTP id
 a640c23a62f3a-b50abaacf16mr3252050266b.32.1760590849991; Wed, 15 Oct 2025
 22:00:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251014231759.136630-1-ebiggers@kernel.org> <20251014231759.136630-3-ebiggers@kernel.org>
In-Reply-To: <20251014231759.136630-3-ebiggers@kernel.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 16 Oct 2025 14:00:37 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8Zwnr2bv85_xEekjOHvSqC7dtfZw+ETZnv1s_d+ZRyiw@mail.gmail.com>
X-Gm-Features: AS18NWCb3A04bIEgGMEL5gPskj-STnWoibK4ZAwcyBSi2FbZ72MTK6-U6uyAbPo
Message-ID: <CAKYAXd8Zwnr2bv85_xEekjOHvSqC7dtfZw+ETZnv1s_d+ZRyiw@mail.gmail.com>
Subject: Re: [PATCH 2/3] ksmbd: Use HMAC-SHA256 library for message signing
 and key generation
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

[snip]
> @@ -8876,22 +8865,21 @@ void smb2_set_sign_rsp(struct ksmbd_work *work)
>         struct kvec *iov;
>         int n_vec = 1;
>
>         hdr = ksmbd_resp_buf_curr(work);
>         hdr->Flags |= SMB2_FLAGS_SIGNED;
> -       memset(hdr->Signature, 0, SMB2_SIGNATURE_SIZE);
By deleting this line, the following error occurs.

[162118.260693] CIFS: VFS: sign fail cmd 0x3 message id 0x3
[162118.260707] CIFS: VFS: \\10.177.110.57 SMB signature verification
returned error = -13
[162118.261473] CIFS: VFS: sign fail cmd 0xb message id 0x4
[162118.261482] CIFS: VFS: \\10.177.110.57 SMB signature verification
returned error = -13
[162118.262437] CIFS: VFS: sign fail cmd 0x3 message id 0x5
[162118.262449] CIFS: VFS: \\10.177.110.57 SMB signature verification
returned error = -13
[162118.262892] CIFS: VFS: sign fail cmd 0x5 message id 0x6
[162118.262900] CIFS: VFS: \\10.177.110.57 SMB signature verification
returned error = -13
[162118.263301] CIFS: VFS: sign fail cmd 0x10 message id 0x7
[162118.263314] CIFS: VFS: \\10.177.110.57 SMB signature verification
returned error = -13
[162118.263724] CIFS: VFS: sign fail cmd 0x10 message id 0x8
[162118.263736] CIFS: VFS: \\10.177.110.57 SMB signature verification
returned error = -13
[162118.264142] CIFS: VFS: sign fail cmd 0x6 message id 0x9
[162118.264154] CIFS: VFS: \\10.177.110.57 SMB signature verification
returned error = -13
[162118.264591] CIFS: VFS: sign fail cmd 0x5 message id 0xa
[162118.264603] CIFS: VFS: \\10.177.110.57 SMB signature verification
returned error = -13
[162118.264912] CIFS: VFS: sign fail cmd 0x6 message id 0xb
[162118.264925] CIFS: VFS: \\10.177.110.57 SMB signature verification
returned error = -13
[162118.265244] CIFS: VFS: sign fail cmd 0x5 message id 0xc
[162118.265257] CIFS: VFS: \\10.177.110.57 SMB signature verification
returned error = -13
[162119.831575] CIFS: VFS: \\10.177.110.57\homes2 SMB signature
verification returned error = -13

I have directly restored this line manually and then applied this
patch to #ksmbd-for-next-next.
Thanks!
>
>         if (hdr->Command == SMB2_READ) {
>                 iov = &work->iov[work->iov_idx - 1];
>                 n_vec++;
>         } else {
>                 iov = &work->iov[work->iov_idx];
>         }
>
> -       if (!ksmbd_sign_smb2_pdu(work->conn, work->sess->sess_key, iov, n_vec,
> -                                signature))
> -               memcpy(hdr->Signature, signature, SMB2_SIGNATURE_SIZE);
> +       ksmbd_sign_smb2_pdu(work->conn, work->sess->sess_key, iov, n_vec,
> +                           signature);
> +       memcpy(hdr->Signature, signature, SMB2_SIGNATURE_SIZE);
>  }
>
>  /**
>   * smb3_check_sign_req() - handler for req packet sign processing
>   * @work:   smb work containing notify command buffer
> diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
> index d742ba754348b..b6e0659a7e414 100644
> --- a/fs/smb/server/smb_common.h
> +++ b/fs/smb/server/smb_common.h
> @@ -407,11 +407,11 @@ struct smb_version_ops {
>         int (*get_ksmbd_tcon)(struct ksmbd_work *work);
>         bool (*is_sign_req)(struct ksmbd_work *work, unsigned int command);
>         int (*check_sign_req)(struct ksmbd_work *work);
>         void (*set_sign_rsp)(struct ksmbd_work *work);
>         int (*generate_signingkey)(struct ksmbd_session *sess, struct ksmbd_conn *conn);
> -       int (*generate_encryptionkey)(struct ksmbd_conn *conn, struct ksmbd_session *sess);
> +       void (*generate_encryptionkey)(struct ksmbd_conn *conn, struct ksmbd_session *sess);
>         bool (*is_transform_hdr)(void *buf);
>         int (*decrypt_req)(struct ksmbd_work *work);
>         int (*encrypt_resp)(struct ksmbd_work *work);
>  };
>
> --
> 2.51.0
>
