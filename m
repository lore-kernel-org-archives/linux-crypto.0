Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444AE13A3F7
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2025 11:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752145686; cv=none; b=KNjdLvZ587nMqP4eay/40Cd6sFy/hRxAWgm61Cy6TubyguYzefcFgDLqVvqDJ+ykEDsOB5YLpsD77+h2PuZlcJXkhgPZ8bCNTAJtimLtcGh65gJM2rMdDkduaiwXq8gzK8WQDrqtVjaUmDs9G0Pdu4A04Zyfv0LZKolRqQCh/3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752145686; c=relaxed/simple;
	bh=scW7lpt9t3K9ITJWzum5EA9tDSAFygNR1A3VRJqSD3A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CiBXfnBaGXPSsybMeb8U9AwGtZeszG/IoiLcUDgq3kajM71qurxNfu5uO1tv+1XeZiL88Gc31saHBuHYw9SwR84rEr5a6YEc2Mk6TRo4b8b/9VkUnePEwXY7U3VR2XiCoBsl8nW8rvQb1eQmOTO/kMWhWyDwBTUJhS/Wt56trxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hzPdgRgZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hzPdgRgZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752145683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oRr959tgklYlTSJNtT9cIXr3gOx1P9lsAQr8MZhrUds=;
	b=hzPdgRgZHT4WDhPNykJy6VMwuRzl0h+jJ9/FdIGCEHvPgq9GBucTNYwY/FCqX7YWLBFjK/
	Sg8VZdjdUjlWCm7T7fLglaEmb0ME2R5SGXNbz81XOxpvQklDhPDH1t8sWcrwMbVTfH2crx
	rxFZQNDxOeab4sKQ7MUGFTXMLcxFa1w=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-N-0zliz_NomC4M6HesRKrA-1; Thu, 10 Jul 2025 07:08:01 -0400
X-MC-Unique: N-0zliz_NomC4M6HesRKrA-1
X-Mimecast-MFC-AGG-ID: N-0zliz_NomC4M6HesRKrA_1752145681
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-53157659c58so2479299e0c.1
        for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2025 04:08:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752145681; x=1752750481;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oRr959tgklYlTSJNtT9cIXr3gOx1P9lsAQr8MZhrUds=;
        b=moR1fA7Bo6IgQYBIfYlJhq47JgpwDSQBO9Vunwik4cqSkcciWdnPO4xP0EIchsqAog
         jRMzfN93KQ/o2eqCOGkh6A/V6ZXBQ+4eAxQCxbaHYQ3KHbO9f49EYetXzYzonHNWDz3W
         WqwcLcZ9Tqp51NRh6cTIqN1lvvgGgzWG2/+/qvVBGKCXAqWr5tsnmOhS36nKNg7rZfgV
         W0K1lssTLE7+eaYGpWFC3u3SMtjE93v7glG8CZ/ROubSW3csIBw5W6MOa/8MgeHdAb9s
         rn2oF5Au5lGxSE9NJtnB75xsj/KpNWWtlSd9QCCPg+BZcPKE+uo+YsiMGjE2rZRzM8uf
         FQZA==
X-Forwarded-Encrypted: i=1; AJvYcCXhe78/SlTztgPAUa26KlrC8UqhyX8t7UkUpyHN05J3UT62kga7q8fb7eeLr0pz+E/V+U8TwGAhRVflqjM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCO8rkBmfG2FBrxy29p8xl8A0Co1kb9vWADDrWd80M29DMuICT
	DGatH7F2ZpOm30kGcGllw/SS8e9xGNXa/cthAWUNZ6h91OlDEu32S9PulS7cQ21CVFul+NaHIHQ
	es5DKW5H3+oBNXkJCQZt5SEzr8TObdPLpnE1UvIVZVxx3JVoBu1BRYriN4JKsI4a3pH+Nsj+zFZ
	iyHbxqmyWJMu6hGHCqp62t+TUPi3/AG4DAxUWC8+SL
X-Gm-Gg: ASbGnctrQzvRHCnbi/cujLmXBDnT0LtEB6WnmST1CEcUec9lTzOIp/Rk3GkMhnwMYBH
	D81HHcCA2jPTrZBwo8zeMWqDf6EyvUDeMyoi+MCFW9dj6UDNREV0paiXML+M0ex0B4OKahaFq0f
	wYGzAE
X-Received: by 2002:a05:6122:788:b0:531:1314:618d with SMTP id 71dfb90a1353d-535e3dc3141mr2472006e0c.0.1752145681117;
        Thu, 10 Jul 2025 04:08:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrFIvf+c9gCePlhiHZ18anazjvea9C/s5gsteYaCXiPys9MekY2/pYF44bBTHRs6JXyKOEgCbgxmRUYU9jd9A=
X-Received: by 2002:a05:6122:788:b0:531:1314:618d with SMTP id
 71dfb90a1353d-535e3dc3141mr2471772e0c.0.1752145679323; Thu, 10 Jul 2025
 04:07:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250710060754.637098-1-ebiggers@kernel.org> <20250710060754.637098-7-ebiggers@kernel.org>
In-Reply-To: <20250710060754.637098-7-ebiggers@kernel.org>
From: Alex Markuze <amarkuze@redhat.com>
Date: Thu, 10 Jul 2025 14:07:47 +0300
X-Gm-Features: Ac12FXxqiJxLMMlU9cjfbI_3W3ee5EBVwZqxnp4Ks340mDQ4Yybgshbv8UUr1rw
Message-ID: <CAO8a2Sivm00NRM9Z-Fwp=FzcmkAP8m1uQR24-avT-tUug4VgmQ@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] ceph: Remove gfp_t argument from ceph_fscrypt_encrypt_*()
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Yuwen Chen <ywen.chen@foxmail.com>, linux-mtd@lists.infradead.org, 
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Alex Markuze amarkuze@redhat.com

On Thu, Jul 10, 2025 at 9:15=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> This argument is no longer used, so remove it.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  fs/ceph/crypto.c | 10 ++++------
>  fs/ceph/crypto.h | 10 ++++------
>  fs/ceph/file.c   |  3 +--
>  fs/ceph/inode.c  |  3 +--
>  4 files changed, 10 insertions(+), 16 deletions(-)
>
> diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
> index 6d04d528ed038..91e62db0c2050 100644
> --- a/fs/ceph/crypto.c
> +++ b/fs/ceph/crypto.c
> @@ -514,12 +514,11 @@ int ceph_fscrypt_decrypt_block_inplace(const struct=
 inode *inode,
>         return fscrypt_decrypt_block_inplace(inode, page, len, offs, lblk=
_num);
>  }
>
>  int ceph_fscrypt_encrypt_block_inplace(const struct inode *inode,
>                                   struct page *page, unsigned int len,
> -                                 unsigned int offs, u64 lblk_num,
> -                                 gfp_t gfp_flags)
> +                                 unsigned int offs, u64 lblk_num)
>  {
>         struct ceph_client *cl =3D ceph_inode_to_client(inode);
>
>         doutc(cl, "%p %llx.%llx len %u offs %u blk %llu\n", inode,
>               ceph_vinop(inode), len, offs, lblk_num);
> @@ -639,21 +638,20 @@ int ceph_fscrypt_decrypt_extents(struct inode *inod=
e, struct page **page,
>   * ceph_fscrypt_encrypt_pages - encrypt an array of pages
>   * @inode: pointer to inode associated with these pages
>   * @page: pointer to page array
>   * @off: offset into the file that the data starts
>   * @len: max length to encrypt
> - * @gfp: gfp flags to use for allocation
>   *
> - * Decrypt an array of cleartext pages and return the amount of
> + * Encrypt an array of cleartext pages and return the amount of
>   * data encrypted. Any data in the page prior to the start of the
>   * first complete block in the read is ignored. Any incomplete
>   * crypto blocks at the end of the array are ignored.
>   *
>   * Returns the length of the encrypted data or a negative errno.
>   */
>  int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **page, =
u64 off,
> -                               int len, gfp_t gfp)
> +                               int len)
>  {
>         int i, num_blocks;
>         u64 baseblk =3D off >> CEPH_FSCRYPT_BLOCK_SHIFT;
>         int ret =3D 0;
>
> @@ -670,11 +668,11 @@ int ceph_fscrypt_encrypt_pages(struct inode *inode,=
 struct page **page, u64 off,
>                 unsigned int pgoffs =3D offset_in_page(blkoff);
>                 int fret;
>
>                 fret =3D ceph_fscrypt_encrypt_block_inplace(inode, page[p=
gidx],
>                                 CEPH_FSCRYPT_BLOCK_SIZE, pgoffs,
> -                               baseblk + i, gfp);
> +                               baseblk + i);
>                 if (fret < 0) {
>                         if (ret =3D=3D 0)
>                                 ret =3D fret;
>                         break;
>                 }
> diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
> index d0768239a1c9c..6db28464ff803 100644
> --- a/fs/ceph/crypto.h
> +++ b/fs/ceph/crypto.h
> @@ -153,19 +153,18 @@ static inline void ceph_fscrypt_adjust_off_and_len(=
struct inode *inode,
>  int ceph_fscrypt_decrypt_block_inplace(const struct inode *inode,
>                                   struct page *page, unsigned int len,
>                                   unsigned int offs, u64 lblk_num);
>  int ceph_fscrypt_encrypt_block_inplace(const struct inode *inode,
>                                   struct page *page, unsigned int len,
> -                                 unsigned int offs, u64 lblk_num,
> -                                 gfp_t gfp_flags);
> +                                 unsigned int offs, u64 lblk_num);
>  int ceph_fscrypt_decrypt_pages(struct inode *inode, struct page **page,
>                                u64 off, int len);
>  int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page=
,
>                                  u64 off, struct ceph_sparse_extent *map,
>                                  u32 ext_cnt);
>  int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **page, =
u64 off,
> -                              int len, gfp_t gfp);
> +                              int len);
>
>  static inline struct page *ceph_fscrypt_pagecache_page(struct page *page=
)
>  {
>         return fscrypt_is_bounce_page(page) ? fscrypt_pagecache_page(page=
) : page;
>  }
> @@ -244,12 +243,11 @@ static inline int ceph_fscrypt_decrypt_block_inplac=
e(const struct inode *inode,
>         return 0;
>  }
>
>  static inline int ceph_fscrypt_encrypt_block_inplace(const struct inode =
*inode,
>                                           struct page *page, unsigned int=
 len,
> -                                         unsigned int offs, u64 lblk_num=
,
> -                                         gfp_t gfp_flags)
> +                                         unsigned int offs, u64 lblk_num=
)
>  {
>         return 0;
>  }
>
>  static inline int ceph_fscrypt_decrypt_pages(struct inode *inode,
> @@ -267,11 +265,11 @@ static inline int ceph_fscrypt_decrypt_extents(stru=
ct inode *inode,
>         return 0;
>  }
>
>  static inline int ceph_fscrypt_encrypt_pages(struct inode *inode,
>                                              struct page **page, u64 off,
> -                                            int len, gfp_t gfp)
> +                                            int len)
>  {
>         return 0;
>  }
>
>  static inline struct page *ceph_fscrypt_pagecache_page(struct page *page=
)
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index a7254cab44cc2..9b79da6d1aee7 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1990,12 +1990,11 @@ ceph_sync_write(struct kiocb *iocb, struct iov_it=
er *from, loff_t pos,
>                         break;
>                 }
>
>                 if (IS_ENCRYPTED(inode)) {
>                         ret =3D ceph_fscrypt_encrypt_pages(inode, pages,
> -                                                        write_pos, write=
_len,
> -                                                        GFP_KERNEL);
> +                                                        write_pos, write=
_len);
>                         if (ret < 0) {
>                                 doutc(cl, "encryption failed with %d\n", =
ret);
>                                 ceph_release_page_vector(pages, num_pages=
);
>                                 break;
>                         }
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 06cd2963e41ee..fc543075b827a 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2434,12 +2434,11 @@ static int fill_fscrypt_truncate(struct inode *in=
ode,
>                 memset(iov.iov_base + boff, 0, PAGE_SIZE - boff);
>
>                 /* encrypt the last block */
>                 ret =3D ceph_fscrypt_encrypt_block_inplace(inode, page,
>                                                     CEPH_FSCRYPT_BLOCK_SI=
ZE,
> -                                                   0, block,
> -                                                   GFP_KERNEL);
> +                                                   0, block);
>                 if (ret)
>                         goto out;
>         }
>
>         /* Insert the header */
> --
> 2.50.1
>
>

