Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C272DAFD6
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2025 11:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752145704; cv=none; b=jFpuzakELAQ3Pte6dBEpyG3sSrRyYpCY5AFnsaqOWqYR5WXL47F9zjhHkOtUVlYAVK0DA2DPzyroODewdp4FiSiFimj7IjkYwbNm68ng0E17TpLIs6ndUpj7aFTBzAMP8cPMEb5FUifj/0J+ieyelnXbrJ30dloGgMAnPN15SpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752145704; c=relaxed/simple;
	bh=hLv7KtHeR2IJpjEA2gsXEz32Asf3LWXa9l8I718Q4NI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cgCe0yv6OvYE9zYloQAVrQ6cFeu9HmqPbjd62sR4qwNwQPndqb9KvjTd0DJ/4wh1DrUMZCQxcV7TtcFItN0vELG9x+q+TAx6G8JHw633txYjMCo6OXr28nXEeUJZAYKQCMZSmH03bm5faEeVu+e50Izqo61mDhLJ0hvjDbdxpeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LvGx/uB8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LvGx/uB8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752145699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W2iF5MdVcoXLNB41BPYMA3hHITImWanFeZV1om8p29w=;
	b=LvGx/uB8SGPVJ560vveShKancpGO3oxLlPae/LwAaIxtbg2dd09+i87xH7IOz4ReAQjM1K
	SruozmZHdZtNVRwhBF7MPls8qqB76yNxyb6BdfjD+qZ1WGk0cLR+axpzUNfFhatnOxFjub
	y/vdxP3hXReeF9dy3mESjoJLgypXODg=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-1_wfhBY4NVuOvCGAvMyCFg-1; Thu, 10 Jul 2025 07:08:16 -0400
X-MC-Unique: 1_wfhBY4NVuOvCGAvMyCFg-1
X-Mimecast-MFC-AGG-ID: 1_wfhBY4NVuOvCGAvMyCFg_1752145696
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-5316d00ecfcso317937e0c.0
        for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2025 04:08:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752145695; x=1752750495;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W2iF5MdVcoXLNB41BPYMA3hHITImWanFeZV1om8p29w=;
        b=SNw/0QNgYqoiYwlmwY9woSE2/nrOMlBLf48wFrbs3vFjSiDgpGqAAFW6mhRUmbdakB
         kK+XdSewmDPl7ehqAu5dV0TFrWHV99mWVHi9BJRHsG5axvr7MzHRbMJPi9ELedu1o0ZJ
         HfWFpUUk3t0uer7OFA4yDdWkOazQaIZH3ivjG4J+nUe4KLjN1Kd6wVrUrRQMVtds9dGT
         1yCPTJRQoMOvS8KptSh7uRVigl2xVsHfy4BxBwylQkGNsKl42f28BOP5j/Dde7EZvLTD
         rsbC2BTb+wAByheedfFhCaXAcHnLWph4U8rB+SFc7KvQSOWr/w9lnGvkDpVrmB0GqwLL
         s18A==
X-Forwarded-Encrypted: i=1; AJvYcCWKNQ5gOzQDfFP9SX2iZRivfelAmgyAgrfAKYdyXZ2mqkorK7zbHVL4JzhysTuYqZTcrqv8j1bSG2snD28=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMRSkdFY2zTAOq6umTmpfU+4bpfH8HRIpbM1XzOqpxoSjc8umo
	XnPNOjNro08zPJGkSAqNQkO2u1gOL9nGHsBB0tpR9m+4KSVUW5NRTkeSAL+TIe7pn/KKMU8dG2b
	i78l3l2xJjDZ9jDy7R66VBVuyIxm/GKl1w/5UmsTPQUlZU9M+hc6qxsvHlAyezn/26pa5P2JlaN
	8HLf8mbjLqEvZQFPVW42i9rT6O8Ulo6nU8Q3YHck3l
X-Gm-Gg: ASbGncvEKRadsKLTpu4cI7iCVFX28+JynR2LA325ACa1j5+Adz+qpXzwk+xwqo5DZaL
	hVv7wMsXF7XSFGMvs/bnfJgBpz4MArID3lYdWreImg6QcR0hTRLOhjPPZyDqxRCDE5dj2Y+c3ze
	HW+pxU
X-Received: by 2002:a05:6122:62b1:b0:520:6773:e5ea with SMTP id 71dfb90a1353d-535e6cad302mr816376e0c.7.1752145695399;
        Thu, 10 Jul 2025 04:08:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG748xi5tENRlmgUwDPKCpmuUZ5DFZugXu5QWkB94zDKhR5MrrRw1zsQESq2LYQJHkYSg59QTKK/bT7AOAWiHA=
X-Received: by 2002:a05:6122:62b1:b0:520:6773:e5ea with SMTP id
 71dfb90a1353d-535e6cad302mr816305e0c.7.1752145694749; Thu, 10 Jul 2025
 04:08:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250710060754.637098-1-ebiggers@kernel.org> <20250710060754.637098-6-ebiggers@kernel.org>
In-Reply-To: <20250710060754.637098-6-ebiggers@kernel.org>
From: Alex Markuze <amarkuze@redhat.com>
Date: Thu, 10 Jul 2025 14:08:04 +0300
X-Gm-Features: Ac12FXxQDl3-eJSLjWpXqvFXfUA71G8ntcV5BboxZYjfuEKf_nyCYrk2ELPh9Bg
Message-ID: <CAO8a2Sie5K_jB-UvhAvRpDEQP-ZJ+rXn9gmkAEXthE65Jrtbbg@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] fscrypt: Remove gfp_t argument from fscrypt_encrypt_block_inplace()
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Yuwen Chen <ywen.chen@foxmail.com>, linux-mtd@lists.infradead.org, 
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Alex Markuze amarkuze@redhat.com

On Thu, Jul 10, 2025 at 9:14=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> This argument is no longer used, so remove it.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  fs/ceph/crypto.c        | 3 +--
>  fs/crypto/crypto.c      | 3 +--
>  fs/ubifs/crypto.c       | 2 +-
>  include/linux/fscrypt.h | 5 ++---
>  4 files changed, 5 insertions(+), 8 deletions(-)
>
> diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
> index 3b3c4d8d401ec..6d04d528ed038 100644
> --- a/fs/ceph/crypto.c
> +++ b/fs/ceph/crypto.c
> @@ -521,12 +521,11 @@ int ceph_fscrypt_encrypt_block_inplace(const struct=
 inode *inode,
>  {
>         struct ceph_client *cl =3D ceph_inode_to_client(inode);
>
>         doutc(cl, "%p %llx.%llx len %u offs %u blk %llu\n", inode,
>               ceph_vinop(inode), len, offs, lblk_num);
> -       return fscrypt_encrypt_block_inplace(inode, page, len, offs, lblk=
_num,
> -                                            gfp_flags);
> +       return fscrypt_encrypt_block_inplace(inode, page, len, offs, lblk=
_num);
>  }
>
>  /**
>   * ceph_fscrypt_decrypt_pages - decrypt an array of pages
>   * @inode: pointer to inode associated with these pages
> diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> index bab0aacd4da36..b6ccab524fdef 100644
> --- a/fs/crypto/crypto.c
> +++ b/fs/crypto/crypto.c
> @@ -215,11 +215,10 @@ EXPORT_SYMBOL(fscrypt_encrypt_pagecache_blocks);
>   * @len:       Size of block to encrypt.  This must be a multiple of
>   *             FSCRYPT_CONTENTS_ALIGNMENT.
>   * @offs:      Byte offset within @page at which the block to encrypt be=
gins
>   * @lblk_num:  Filesystem logical block number of the block, i.e. the 0-=
based
>   *             number of the block within the file
> - * @gfp_flags: Memory allocation flags
>   *
>   * Encrypt a possibly-compressed filesystem block that is located in an
>   * arbitrary page, not necessarily in the original pagecache page.  The =
@inode
>   * and @lblk_num must be specified, as they can't be determined from @pa=
ge.
>   *
> @@ -227,11 +226,11 @@ EXPORT_SYMBOL(fscrypt_encrypt_pagecache_blocks);
>   *
>   * Return: 0 on success; -errno on failure
>   */
>  int fscrypt_encrypt_block_inplace(const struct inode *inode, struct page=
 *page,
>                                   unsigned int len, unsigned int offs,
> -                                 u64 lblk_num, gfp_t gfp_flags)
> +                                 u64 lblk_num)
>  {
>         if (WARN_ON_ONCE(inode->i_sb->s_cop->supports_subblock_data_units=
))
>                 return -EOPNOTSUPP;
>         return fscrypt_crypt_data_unit(inode->i_crypt_info, FS_ENCRYPT,
>                                        lblk_num, page, page, len, offs);
> diff --git a/fs/ubifs/crypto.c b/fs/ubifs/crypto.c
> index 921f9033d0d2d..fb5ac358077b1 100644
> --- a/fs/ubifs/crypto.c
> +++ b/fs/ubifs/crypto.c
> @@ -49,11 +49,11 @@ int ubifs_encrypt(const struct inode *inode, struct u=
bifs_data_node *dn,
>         /* pad to full block cipher length */
>         if (pad_len !=3D in_len)
>                 memset(p + in_len, 0, pad_len - in_len);
>
>         err =3D fscrypt_encrypt_block_inplace(inode, virt_to_page(p), pad=
_len,
> -                                           offset_in_page(p), block, GFP=
_NOFS);
> +                                           offset_in_page(p), block);
>         if (err) {
>                 ubifs_err(c, "fscrypt_encrypt_block_inplace() failed: %d"=
, err);
>                 return err;
>         }
>         *out_len =3D pad_len;
> diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
> index 56fad33043d53..8d0e3ad89b940 100644
> --- a/include/linux/fscrypt.h
> +++ b/include/linux/fscrypt.h
> @@ -312,11 +312,11 @@ void fscrypt_enqueue_decrypt_work(struct work_struc=
t *);
>
>  struct page *fscrypt_encrypt_pagecache_blocks(struct folio *folio,
>                 size_t len, size_t offs, gfp_t gfp_flags);
>  int fscrypt_encrypt_block_inplace(const struct inode *inode, struct page=
 *page,
>                                   unsigned int len, unsigned int offs,
> -                                 u64 lblk_num, gfp_t gfp_flags);
> +                                 u64 lblk_num);
>
>  int fscrypt_decrypt_pagecache_blocks(struct folio *folio, size_t len,
>                                      size_t offs);
>  int fscrypt_decrypt_block_inplace(const struct inode *inode, struct page=
 *page,
>                                   unsigned int len, unsigned int offs,
> @@ -485,12 +485,11 @@ static inline struct page *fscrypt_encrypt_pagecach=
e_blocks(struct folio *folio,
>  }
>
>  static inline int fscrypt_encrypt_block_inplace(const struct inode *inod=
e,
>                                                 struct page *page,
>                                                 unsigned int len,
> -                                               unsigned int offs, u64 lb=
lk_num,
> -                                               gfp_t gfp_flags)
> +                                               unsigned int offs, u64 lb=
lk_num)
>  {
>         return -EOPNOTSUPP;
>  }
>
>  static inline int fscrypt_decrypt_pagecache_blocks(struct folio *folio,
> --
> 2.50.1
>
>

