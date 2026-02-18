Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4C72F1FF1
	for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 21:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771450956; cv=pass; b=uWajGayTly8024raCW3qBSuHKwKkuvVq9In3iYNSEY1hp/XpxwT/pYyTpGOnzOysxVwmYR6Oe2mZtL30jm3fzRSSw782oeuKJww/ZUS2zJ+Ct8i+ds5Zc/ghAZ/24xwYZUydma7b1Fjs8qx6jyW2hGf7/qJ+lnTJswxsTP3YKB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771450956; c=relaxed/simple;
	bh=Kut9itH4KGS+1jezuu1kMPaauhlTNVrL1GqgQMwPuCs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FLuGB43/y0I/wqZqbPYEcc91zlUCecYok4lUqDdr8WWGSbsamBFLGkEQTaSDzzDzF3DNo7dhL5YyG3N++TyVWg621eUw5Be+NaGtPA/CzBi653gLTgo5XHuG+GQmXcBjPQ8UdzvOp6rb6OG4KKxiXYSN7ObD2Qjro7thm1d/+p0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cWq3uxCe; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cWq3uxCe"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-895341058b1so3193106d6.3
        for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 13:42:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771450953; cv=none;
        d=google.com; s=arc-20240605;
        b=B0Sw7yRvEFV9MRUMyRgxaGTTPviNGrCETj0dT+FvvCSj5Wmgmcpo0EFUkh++iIbxbE
         0bk+yx9mua3Ehagdssb5o+S7BQk/Lib2ALV0apSg3xcyrQEf9KyHBJubZGKbYzlMpxGH
         GL2zrO66blkGfbcTuuhSbmyTn7Qsra/kPwEUbw8pVL+oWIQ6Awck7IXTsiLKabV6bpwr
         Dvqtf6RiXLfzUUpTc24e1476zUChdIE018fGfltViWjk4xKZHvhNX0tV9PgQlY4M1026
         cwnEOXwgoPTkzGzLjLOS62Gdepf20VppJKxewXMYgoikjeH9ttWxDbl24H5Jxr1FFl+8
         Gt4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fdl0A8UixsIff/MQ5v+B5jVRqHb5yulzDbRj1E6u3Cs=;
        fh=nFkfQU0GcUHKwWKQmU8/Baa2NPjH5Oi2jac5EQXFsPY=;
        b=irGuzYrmWp127141QbwLiYbncmIrgM04IDA92Yz7gL+ik34SvbDIDQx33xuF1KVs1a
         kbJmzxn2z6hashtSO8eKP9gC6SM/x3Kmb881cfcCkHPcJ3pB+y/0l+mncI/q/VQ4RH9N
         iOTVIhE0N8gryKyoxIj/vCE7U8TmH8WLd6vEXPQuIax3g22btIKGgFDRmmaOYpXOg5yH
         RAcoc1A7ujR0ghq2b2bTz/fXV8ARUCJc29gx9EzN5uhz1KJoH6p7dAJ93OV4+iiMOg8q
         ongxrFhZyY/Mmi9xF2E6vXQxJ7mykrjAYRi7sWyjUEX1UPup1qDobs9iI8zxlE7oeQky
         YjtA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771450953; x=1772055753; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fdl0A8UixsIff/MQ5v+B5jVRqHb5yulzDbRj1E6u3Cs=;
        b=cWq3uxCeBP9EK2ynO2MhTibZAvHgXAbDCJ8BbKl2BiPdoTj6B+pUSGxpaqwltdSmx+
         Al97xgil93Qi2LGQDWzEvIYCtZ7QpARlbap4ofdKmPaL9FcdUehcLcHCoNGFTKIjcLne
         3x3F3I3j6yo8e2d6HASYqKHfJYSXnoQhpFOpH585+Ijz3Tqn11Lf4ObZhqcwusBHpfDq
         gMluBg9wh7NB00sn184MYLNH8hn69tETFM45HEgr6/dv3oPCbZAEyf68lPF6OsKtDJn4
         o4L/2/8cM9aBXYjvbyoz2OjVFK1LhS9GKShH1uW74B6iH71BXuLmYJkLChdDxcXmIdKc
         2juA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771450953; x=1772055753;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fdl0A8UixsIff/MQ5v+B5jVRqHb5yulzDbRj1E6u3Cs=;
        b=v7Vk57kKROvMyTQtNzyrridBFCOUwP12yvBBYKUs2XlKFcvOfmWM7HlPnq2ZoUw25o
         ZZQWgf4jhEh/51YGNLgMaUcyp6KBl3tJkdEb7J8F1fO2DCoomONhNBPpvhw+4M6g2bFF
         Sv2qsM+uviM0PaJ+34krjNf5c5IyrasZw2uUo+99NhTviy+B9uaL1cbJtaxc+Mp5A6Wj
         v7Vpxt1ooxw5xc6NL52buk1w7m0IC4ZgMTAc0ziPZaAW+qiCSkN4jYMYYlWkIiTMDBzO
         60EE2+h+3vA8JdUVm9RaOTx+g9kYC+AkqX+g04im4D/50BMEdcATxQRRNwDXvFoLQY9r
         go3w==
X-Gm-Message-State: AOJu0YzfIqu0b0SZGMJYpEBOtSswy+EVGoStqj7fCNwIZAlId4bJQsnH
	oGRjT3U8WbhJMjeysDQCSh7zFLNzqY+QdGelM1/KYjGKdXID4uq9pkQOTwSjSCJ7eylXqjLqB7v
	S1htcRhXVmhlAJ3iwxQbX7G9SI84q2UE=
X-Gm-Gg: AZuq6aIQygY+4dNa7YiODCY+OpI3UJdl5dfjS5soNwl233h1Rsb1haGVaG2udT43Fzw
	BzzJcWiP81SD0HjlxwpQKwib8bOpVIu7xDXUtYR4tzuyfM1eH9RqD9W1GC3fArV7RPwQp91geLg
	90vt2e+TRC4cb5xggpQSmmYLB6U/NjGwfrx5lq9RdCQ7wyiDT6cQDkXxvl4XOjJB2HJB2y2ECLm
	AKNXufIk7FnV3hr4fnktgzRLaL731enq8qOC2fkFRzhi85yzaxbh750ZTrHNywrthhoHBKhl8Qu
	2sXXSYhj3bvVg2jZcWUxPCUSlSLA1lj8XoD/mMWjJsm/giQU7OEJFLl0Nn6t8KhuPY2BPw1Tmzk
	nWH6Ld4kk2MyWOjNHWPxud3AIrqvbUiNDwPE3kdB7BwrWAVx3Z2/+4qsELOvnU+DUAjuOMjry9E
	0cYZSwAzP1zQS9+O6bblC7Yw==
X-Received: by 2002:a05:6214:202b:b0:897:306d:98b9 with SMTP id
 6a1803df08f44-897402d74ddmr259168586d6.11.1771450953049; Wed, 18 Feb 2026
 13:42:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260218213501.136844-1-ebiggers@kernel.org> <20260218213501.136844-12-ebiggers@kernel.org>
In-Reply-To: <20260218213501.136844-12-ebiggers@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 18 Feb 2026 15:42:22 -0600
X-Gm-Features: AaiRm51OR0UA1EoYTzTIBq9EZMqc4hCYgiV_-Pm5bfpkALLXMax-4eNCD0kf6YQ
Message-ID: <CAH2r5msdQw2KLyMJMoSrzFoGoJfmuCsBj_qeT34sH5b+6DLWFQ@mail.gmail.com>
Subject: Re: [PATCH 11/15] smb: client: Drop 'allocate_crypto' arg from smb*_calc_signature()
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-kernel@lists.infradead.org, 
	linux-cifs@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Acked-by: Steve French <stfrench@microsoft.com>

On Wed, Feb 18, 2026 at 3:38=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> Since the crypto library API is now being used instead of crypto_shash,
> all structs for MAC computation are now just fixed-size structs
> allocated on the stack; no dynamic allocations are ever required.
> Besides being much more efficient, this also means that the
> 'allocate_crypto' argument to smb2_calc_signature() and
> smb3_calc_signature() is no longer used.  Remove this unused argument.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  fs/smb/client/smb2transport.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.=
c
> index 0176185a1efc..41009039b4cb 100644
> --- a/fs/smb/client/smb2transport.c
> +++ b/fs/smb/client/smb2transport.c
> @@ -202,12 +202,11 @@ smb2_find_smb_tcon(struct TCP_Server_Info *server, =
__u64 ses_id, __u32  tid)
>
>         return tcon;
>  }
>
>  static int
> -smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *serve=
r,
> -                   bool allocate_crypto)
> +smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *serve=
r)
>  {
>         int rc;
>         unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
>         struct kvec *iov =3D rqst->rq_iov;
>         struct smb2_hdr *shdr =3D (struct smb2_hdr *)iov[0].iov_base;
> @@ -438,12 +437,11 @@ generate_smb311signingkey(struct cifs_ses *ses,
>
>         return generate_smb3signingkey(ses, server, &triplet);
>  }
>
>  static int
> -smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *serve=
r,
> -                   bool allocate_crypto)
> +smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *serve=
r)
>  {
>         int rc;
>         unsigned char smb3_signature[SMB2_CMACAES_SIZE];
>         struct kvec *iov =3D rqst->rq_iov;
>         struct smb2_hdr *shdr =3D (struct smb2_hdr *)iov[0].iov_base;
> @@ -451,11 +449,11 @@ smb3_calc_signature(struct smb_rqst *rqst, struct T=
CP_Server_Info *server,
>         struct aes_cmac_ctx cmac_ctx;
>         struct smb_rqst drqst;
>         u8 key[SMB3_SIGN_KEY_SIZE];
>
>         if (server->vals->protocol_id <=3D SMB21_PROT_ID)
> -               return smb2_calc_signature(rqst, server, allocate_crypto)=
;
> +               return smb2_calc_signature(rqst, server);
>
>         rc =3D smb3_get_sign_key(le64_to_cpu(shdr->SessionId), server, ke=
y);
>         if (unlikely(rc)) {
>                 cifs_server_dbg(FYI, "%s: Could not get signing key\n", _=
_func__);
>                 return rc;
> @@ -522,11 +520,11 @@ smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Se=
rver_Info *server)
>         if (!is_binding && !server->session_estab) {
>                 strscpy(shdr->Signature, "BSRSPYL");
>                 return 0;
>         }
>
> -       return smb3_calc_signature(rqst, server, false);
> +       return smb3_calc_signature(rqst, server);
>  }
>
>  int
>  smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *ser=
ver)
>  {
> @@ -558,11 +556,11 @@ smb2_verify_signature(struct smb_rqst *rqst, struct=
 TCP_Server_Info *server)
>          */
>         memcpy(server_response_sig, shdr->Signature, SMB2_SIGNATURE_SIZE)=
;
>
>         memset(shdr->Signature, 0, SMB2_SIGNATURE_SIZE);
>
> -       rc =3D smb3_calc_signature(rqst, server, true);
> +       rc =3D smb3_calc_signature(rqst, server);
>
>         if (rc)
>                 return rc;
>
>         if (crypto_memneq(server_response_sig, shdr->Signature,
> --
> 2.53.0
>
>


--=20
Thanks,

Steve
