Received: from mail-ed2-f40.google.com (mail-ed2-f40.google.com [74.125.228.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1714D6C53
	for <linux-crypto@vger.kernel.org>; Fri, 25 Sep 2026 15:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790351468; cv=none; b=NRUnwgMI7AjKN6RwaISavhHjr07RXstgCJJB2lySrlALDwZsytjc1CbnDHgrLC38VpPTWhqWFIkwQCcFFUrMEZqODuWDOrOuZgfzz3vuZuEX10GOXtApt2OCjVHBAmlisE68nQbZBNsx4n+GubYC9gt/K2oITuNQnQGrXjLesEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790351468; c=relaxed/simple;
	bh=8Sl6QXs9f/prUlQJGcMmVpKU9w+SU9Wg3hJmmffsgtA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t407/y0xOy+rpotjUsm1t6JiVxWrEn44TlhGMwb+nzFcIKcdwzrld3ZX+jQx0YHFhgVjHOMPbT2DpnDhDCV4E1/VCKuu2qA4Cjjh10SRxkPhEEZ25XsDUe0c352017Es2RWdU0eUBLYEcimvNjIVDNVYT4m92Ko2S+J/Ec7W2tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.228.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed2-f40.google.com with SMTP id 4fb4d7f45d1cf-6a60590a85cso1998499a12.0
        for <linux-crypto@vger.kernel.org>; Fri, 25 Sep 2026 08:51:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790351464; x=1790956264;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n7HjLJsKXetAb0Aw0AgEZE0vzcstRBizx1Ha0tT6wh0=;
        b=IXpDPCGrdqHvuvIz2atFHqsEl241xRB7KOanU8gmyAyZfsaobwiidr+kiWAZVbaTnh
         fdx+PqaYy85KyEWkWfj/QrlzSFqbDlX+X0mOtMaK0PN+3ttn0mkRzeuxEb5hKi4MgNNb
         KYpDRd3xScp2xsjAeI1mn2x8pP+0HXDNDAZAQgz+6GbJ4YrbHs80Fs5h20MGjJONIco+
         Rm4mh1ENLnzyXycYUQMjFMgoOAFb7B0LRaGHrF9OqnB4Jme02C9Z9xhO+myCpvvAhOFi
         s4WY/Ki0wIx8VKGT2Z3of/T1VMKp2k7Tcm/34SJOzWAqk+Lf+hBA/PJ+xHsI/VFh52BM
         V+/Q==
X-Forwarded-Encrypted: i=1; AKwUvBwOvidWnVp/DekzARHypKLxlaZI8a7V4JrtjxMx6kuNxFf7pPD0ZEqtxE7u4suYwFYAcQx5hZqtIDYWbUI=@vger.kernel.org
X-Gm-Message-State: AFuF++m+KxmaB1KkLLn+lKC2vbsPofdZCPsaS+EBys+iGhdVGQQctFwl
	21mIT39KYzvXZ2TLE7Rgz/xb2kZrJObvrMWzt5zzQ0LEzYx23ql4mLV1xuhLNsA7gns=
X-Gm-Gg: AYBFou2bDYFULRKld3ypL7/AxJX3Ro3GGTa8ozY/ODRGZqqTZziczGlj5dO6Eaadf4v
	29FCuPdOcsU0QQoLRQiqII6CUePKicxHEl5C+gHz55yuPQ1Hs4oPWkujysIwPjGIxRh1Ga2pVKi
	mri/PKXJCWd9Qx/FeZM6JlnenMyJTsbbOSbjIqa4Qzc/n4anjGrbYMeFrntRYtrRp8dnU8GcX4T
	tnCE94CBwKWVKD+PIwUpPJiJPtBcRov4rI+MXGrykEesbY3N24F56z/vSmXx8rjRF9BoNYmkJzN
	M3hXKfnSsKvboBok9BJnQg7VpOYHbG03KJ20rFqDm4SQXRUVQnkilIohrtyrF0C3TCwp4jPNJpO
	NDjp57UjfCxzjOMcHlis+DZ9CPedIsTuCjAflxU2x0lPPQ8RmbI3ZFYIkhF4wkTTiu34KOfjOBj
	al8ysfKbQhU5Z8JS7IYhQE5C78nD1f6pFjQBgu6u88m2qG/HLWAHJecfrscOn9V+Ay0zpYBYeag
	STXghnhPuqttJ7c8EtMu8DBFX1JsLo=
X-Received: by 2002:a17:907:db18:b0:c25:8878:3e09 with SMTP id a640c23a62f3a-c2ac242e380mr578248666b.22.1790351464557;
        Fri, 25 Sep 2026 08:51:04 -0700 (PDT)
Received: from mail-ej2-f17.google.com (mail-ej2-f17.google.com. [74.125.228.145])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2ae76b3f6dsm128677266b.42.2026.09.25.08.51.04
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2026 08:51:04 -0700 (PDT)
Received: by mail-ej2-f17.google.com with SMTP id a640c23a62f3a-c29d50b7cf9so170266666b.2
        for <linux-crypto@vger.kernel.org>; Fri, 25 Sep 2026 08:51:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxXE7jT9eu396T8H6+DgLY3mm4ldk6xUEW2ljVIwKj0ycxpnmaBTG23qPiapyRfI5C3+VyXsLznTpquMq0=@vger.kernel.org
X-Received: by 2002:a17:907:e918:b0:c2a:9e6a:3b4e with SMTP id
 a640c23a62f3a-c2ac228e60cmr567189166b.0.1790351463882; Fri, 25 Sep 2026
 08:51:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260919223438.3883567-1-benquike@gmail.com> <CAHC9VhS7sZQaPaRswKQ1ETrReEPB2f5buNAMGSXqZ1iBKTs+bg@mail.gmail.com>
 <20260920235249.260530-1-benquike@gmail.com>
In-Reply-To: <20260920235249.260530-1-benquike@gmail.com>
From: Ignat Korchagin <ignat@linux.win>
Date: Fri, 25 Sep 2026 16:50:51 +0100
X-Gmail-Original-Message-ID: <CAOs+rJVgp-mG1PtqHKnSejjnXiw8n6MA5ye2JGHoL0=JUADAzQ@mail.gmail.com>
X-Gm-Features: AclHuK8AHjiRwMxnh93efSsuU_hhOCN66FUp5ELHqoUEvyW1GbfwsAHY6Z1odGA
Message-ID: <CAOs+rJVgp-mG1PtqHKnSejjnXiw8n6MA5ye2JGHoL0=JUADAzQ@mail.gmail.com>
Subject: Re: [PATCH v2] certs: x509: duplicate cert->tbs when
 sig->algo_takes_data is set
To: Hui Peng <benquike@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Paul Moore <paul@paul-moore.com>, 
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 12:52=E2=80=AFAM Hui Peng <benquike@gmail.com> wrot=
e:
>
> In x509_get_sig_params(), when sig->algo_takes_data is true, sig->m is
> assigned (u8 *)cert->tbs with sig->m_free =3D false. However, cert->tbs
> points into the temporary ASN.1 buffer (prep->data) passed to
> x509_cert_parse(), while cert->sig is retained in
> prep->payload.data[asym_auth] by x509_key_preparse() after prep->data
> is freed by the caller. Subsequent signature verification on the key's
> public_key_signature dereferences the freed TBS buffer.
>
> Duplicate cert->tbs with kmemdup() and set sig->m_free =3D true so sig->m
> remains valid for the lifetime of struct public_key_signature.
>
> Tested in QEMU against Linux 7.3.0-rc3 with KASAN enabled by adding an
> ML-DSA-44 (OID 2.16.840.1.101.3.4.3.17) X.509 certificate via
> add_key("asymmetric", ...) and linking it into a signature-restricted
> keyring via keyctl(KEYCTL_LINK), which triggers the following KASAN
> slab-use-after-free before this patch:
>
>   BUG: KASAN: slab-use-after-free in mldsa_verify+0x95/0xa0 [mldsa]
>   Read of size 1 at addr ffff88800108c004 by task init/1
>
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x70/0xa0
>    print_report+0x153/0x4c6
>    kasan_report+0xf1/0x120
>    mldsa_verify+0x95/0xa0 [mldsa]
>    public_key_verify_signature+0x5cb/0x8e0
>    verify_signature+0xe4/0x130
>    key_or_keyring_common+0x428/0x850
>    key_link+0x22e/0x360
>    keyctl_keyring_link+0x6b/0xc0
>    __do_sys_keyctl+0x146/0x4f0
>    do_syscall_64+0xda/0x4b0
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>    </TASK>
>
>   Allocated by task 1:
>    kasan_save_stack+0x30/0x50
>    kasan_save_track+0x14/0x30
>    __kasan_kmalloc+0x7f/0x90
>    __kvmalloc_node_noprof+0x1c2/0x5b0
>    __do_sys_add_key+0x1c2/0x390
>    do_syscall_64+0xda/0x4b0
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
>   Freed by task 1:
>    kasan_save_stack+0x30/0x50
>    kasan_save_track+0x14/0x30
>    kasan_save_free_info+0x3b/0x70
>    __kasan_slab_free+0x47/0x70
>    kfree+0x159/0x420
>    __do_sys_add_key+0x2b3/0x390
>    do_syscall_64+0xda/0x4b0
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
>   The buggy address belongs to the object at ffff88800108c000
>    which belongs to the cache kmalloc-4k of size 4096
>   The buggy address is located 4 bytes inside of
>    freed 4096-byte region [ffff88800108c000, ffff88800108d000)
>
> Fixes: f3eccecd782d ("pkcs7: Allow the signing algo to do whatever digest=
ion it wants itself")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Hui Peng <benquike@gmail.com>

Reviewed-by: Ignat Korchagin <ignat@linux.win>

> ---
> Changes in v2:
> - Dropped the net/netlabel/netlabel_calipso.c change, keeping only the
>   crypto/asymmetric_keys/x509_public_key.c fix.
> - Added the KASAN slab-use-after-free report and test description to the
>   commit message.
>
>  crypto/asymmetric_keys/x509_public_key.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric=
_keys/x509_public_key.c
> index 25cf8ac7f257..5c9165a83f91 100644
> --- a/crypto/asymmetric_keys/x509_public_key.c
> +++ b/crypto/asymmetric_keys/x509_public_key.c
> @@ -53,9 +53,11 @@ int x509_get_sig_params(struct x509_certificate *cert)
>
>         if (sig->algo_takes_data) {
>                 /* The signature algorithm does whatever passes for hashi=
ng. */
> -               sig->m =3D (u8 *)cert->tbs;
> +               sig->m =3D kmemdup(cert->tbs, cert->tbs_size, GFP_KERNEL)=
;
> +               if (!sig->m)
> +                       return -ENOMEM;
>                 sig->m_size =3D cert->tbs_size;
> -               sig->m_free =3D false;
> +               sig->m_free =3D true;
>                 goto out;
>         }
>
> --
> 2.47.3
>

Thanks
