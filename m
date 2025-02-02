Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FFB1F9EAA;
	Sun,  2 Feb 2025 14:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738506510; cv=none; b=TIVzspnAsetdYsQgCw9QASTIHjLHDuUh8a/aFvHZF9XHH3BsoyS6ea1OEQtiaviIDIg4nTMqGBfXgLFXkbvDqNoKFujZ9eOtlgdjyNCtXfDStTTYiSB2llWVGG3AmrSlXDBbf3GgI8AULUo5G3qz+QYpl9WuAvmEwg2GoBWwkXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738506510; c=relaxed/simple;
	bh=TbHnexXWIxt5OgTXEHvE/eho/cQ3iS/JB6BFrj4S+Rw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fDlvXEMbyG3ifKZkYDXg62V0JdG8iCNKnZHTASQ6/cRWc4mxzYGH4RHWKCpt5zKQ4KNKHQ4qaTZpCadpXvnpYfa4XYsMKwy6zLQLmTXHRacU6brA1vhnJHRHVF/suDIVJLkWUq1SfPJrkcQ9+FsfQqydg0qVH2ifOZnle4kMhKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fXjJUI7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXjJUI7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA243C4CED1;
	Sun,  2 Feb 2025 14:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738506510;
	bh=TbHnexXWIxt5OgTXEHvE/eho/cQ3iS/JB6BFrj4S+Rw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fXjJUI7adKHRCHbnYJvA8KTJKsKmnTX+Z1l4bqOB538SFb5HAHBETRUNzXYTGhzxV
	 SxZdYQ0YWUOUk3WjYEnrDugBEyf3+E6+5JMJANTlAlam5R6aBf1f0idblplS98InEW
	 9pbp7AKauvBQ2yWIFjc0b8sKmtGI4QPr5MXDu0sT0fEbb/ihl/cDp2ufvlTiTQYaJz
	 PtmCs8ua41hJIZ+eeaO3oNZqhSBU792buMgm65OOiThQnX5EdNbwvzRiDzp78x+7zp
	 DfSiO2vYTE/pxiQiPQGEPNNEaqNBirSz18CreiNCUECwYq2dW38pgVenGpzP86ddil
	 uMY8m2PCits9w==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-540218726d5so3294713e87.2;
        Sun, 02 Feb 2025 06:28:29 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXDwoDWAt5Icx29CEO8CXs/UCmaVyGzABynLpEx6j0QC4NvUDtoPF2YgtqlAMVWkFmmUeT2FpUk76KVNA==@vger.kernel.org, AJvYcCXyWLOIM+O8NrscDw/+BV9xjvb/K8IHtuvbY1EiE1jHjQDCCoYOKsOVrwDZbWQLIomLnzO+gy7K8V+J4Zng@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg5a2iq4qeZ6Ls4+mVuzxEcH3by/dlYNyNC5pLspzfhxatTXHK
	b5alcAsP/SiAq/2zc4u4wq5w+89/b7ciLT2Yn+Cjlt6bWk1kX5PsvYhITVHNrwprjvmbe+wiL7k
	HISXHGm0hPp2/agusNdOhM1ttU4o=
X-Google-Smtp-Source: AGHT+IGJCchryob5bg5f6cAhg6C9cb5PG1bbxiQL+QMU1QDM4jxF50fMNUClnvy1Zx21AN8tuMXhI7bmWThSVYTmwe0=
X-Received: by 2002:a05:6512:2244:b0:543:e41a:ff76 with SMTP id
 2adb3069b0e04-543e4bdfed7mr6428305e87.3.1738506508266; Sun, 02 Feb 2025
 06:28:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250130035130.180676-1-ebiggers@kernel.org> <20250130035130.180676-4-ebiggers@kernel.org>
In-Reply-To: <20250130035130.180676-4-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sun, 2 Feb 2025 15:28:17 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGmMof1jDCPwVRdWeB7+_a8zv8MDZ+7oWDCx2TTNoGndg@mail.gmail.com>
X-Gm-Features: AWEUYZlMLaOJH_ZGHpZjCZSekSMACFzRU-UFEyxy8qZQgZnViZAGUZtozcplFps
Message-ID: <CAMj1kXGmMof1jDCPwVRdWeB7+_a8zv8MDZ+7oWDCx2TTNoGndg@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] lib/crc64: rename CRC64-Rocksoft to CRC64-NVME
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 30 Jan 2025 at 04:54, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> This CRC64 variant comes from the NVME NVM Command Set Specification
> (https://nvmexpress.org/wp-content/uploads/NVM-Express-NVM-Command-Set-Specification-1.0e-2024.07.29-Ratified.pdf).
>
> The "Rocksoft Model CRC Algorithm", published in 1993 and available at
> https://www.zlib.net/crc_v3.txt, is a generalized CRC algorithm that can
> calculate any variant of CRC, given a list of parameters such as
> polynomial, bit order, etc.  It is not a CRC variant.
>
> The NVME NVM Command Set Specification has a table that gives the
> "Rocksoft Model Parameters" for the CRC variant it uses.  When support
> for this CRC variant was added to Linux, this table seems to have been
> misinterpreted as naming the CRC variant the "Rocksoft" CRC.  In fact,
> the CRC variant is not explicitly named by the NVME spec.
>
> Most implementations of this CRC variant outside Linux have been calling
> it CRC64-NVME.  Therefore, update Linux to match.
>
> While at it, remove the superfluous "update" from the function name, so
> crc64_rocksoft_update() is now just crc64_nvme(), matching most of the
> other CRC library functions.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  block/t10-pi.c        |  2 +-
>  include/linux/crc64.h | 11 +++++++----
>  lib/crc64.c           | 10 +++++-----
>  lib/gen_crc64table.c  | 10 +++++-----
>  4 files changed, 18 insertions(+), 15 deletions(-)
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/block/t10-pi.c b/block/t10-pi.c
> index 2d05421f0fa5..2577114ff20c 100644
> --- a/block/t10-pi.c
> +++ b/block/t10-pi.c
> @@ -208,11 +208,11 @@ static void t10_pi_type1_complete(struct request *rq, unsigned int nr_bytes)
>         }
>  }
>
>  static __be64 ext_pi_crc64(u64 crc, void *data, unsigned int len)
>  {
> -       return cpu_to_be64(crc64_rocksoft_update(crc, data, len));
> +       return cpu_to_be64(crc64_nvme(crc, data, len));
>  }
>
>  static void ext_pi_crc64_generate(struct blk_integrity_iter *iter,
>                 struct blk_integrity *bi)
>  {
> diff --git a/include/linux/crc64.h b/include/linux/crc64.h
> index 7880aeab69d6..17cf5af3e78e 100644
> --- a/include/linux/crc64.h
> +++ b/include/linux/crc64.h
> @@ -6,20 +6,23 @@
>  #define _LINUX_CRC64_H
>
>  #include <linux/types.h>
>
>  u64 __pure crc64_be(u64 crc, const void *p, size_t len);
> -u64 __pure crc64_rocksoft_generic(u64 crc, const void *p, size_t len);
> +u64 __pure crc64_nvme_generic(u64 crc, const void *p, size_t len);
>
>  /**
> - * crc64_rocksoft_update - Calculate bitwise Rocksoft CRC64
> + * crc64_nvme - Calculate CRC64-NVME
>   * @crc: seed value for computation. 0 for a new CRC calculation, or the
>   *      previous crc64 value if computing incrementally.
>   * @p: pointer to buffer over which CRC64 is run
>   * @len: length of buffer @p
> + *
> + * This computes the CRC64 defined in the NVME NVM Command Set Specification,
> + * *including the bitwise inversion at the beginning and end*.
>   */
> -static inline u64 crc64_rocksoft_update(u64 crc, const u8 *p, size_t len)
> +static inline u64 crc64_nvme(u64 crc, const u8 *p, size_t len)
>  {
> -       return crc64_rocksoft_generic(crc, p, len);
> +       return crc64_nvme_generic(crc, p, len);
>  }
>
>  #endif /* _LINUX_CRC64_H */
> diff --git a/lib/crc64.c b/lib/crc64.c
> index b5136fb4c199..d6f3f245eede 100644
> --- a/lib/crc64.c
> +++ b/lib/crc64.c
> @@ -20,12 +20,12 @@
>   * x^64 + x^62 + x^57 + x^55 + x^54 + x^53 + x^52 + x^47 + x^46 + x^45 +
>   * x^40 + x^39 + x^38 + x^37 + x^35 + x^33 + x^32 + x^31 + x^29 + x^27 +
>   * x^24 + x^23 + x^22 + x^21 + x^19 + x^17 + x^13 + x^12 + x^10 + x^9 +
>   * x^7 + x^4 + x + 1
>   *
> - * crc64rocksoft[256] table is from the Rocksoft specification polynomial
> - * defined as,
> + * crc64nvmetable[256] uses the CRC64 polynomial from the NVME NVM Command Set
> + * Specification and uses least-significant-bit first bit order:
>   *
>   * x^64 + x^63 + x^61 + x^59 + x^58 + x^56 + x^55 + x^52 + x^49 + x^48 + x^47 +
>   * x^46 + x^44 + x^41 + x^37 + x^36 + x^34 + x^32 + x^31 + x^28 + x^26 + x^23 +
>   * x^22 + x^19 + x^16 + x^13 + x^12 + x^10 + x^9 + x^6 + x^4 + x^3 + 1
>   *
> @@ -61,18 +61,18 @@ u64 __pure crc64_be(u64 crc, const void *p, size_t len)
>
>         return crc;
>  }
>  EXPORT_SYMBOL_GPL(crc64_be);
>
> -u64 __pure crc64_rocksoft_generic(u64 crc, const void *p, size_t len)
> +u64 __pure crc64_nvme_generic(u64 crc, const void *p, size_t len)
>  {
>         const unsigned char *_p = p;
>         size_t i;
>
>         crc = ~crc;
>
>         for (i = 0; i < len; i++)
> -               crc = (crc >> 8) ^ crc64rocksofttable[(crc & 0xff) ^ *_p++];
> +               crc = (crc >> 8) ^ crc64nvmetable[(crc & 0xff) ^ *_p++];
>
>         return ~crc;
>  }
> -EXPORT_SYMBOL_GPL(crc64_rocksoft_generic);
> +EXPORT_SYMBOL_GPL(crc64_nvme_generic);
> diff --git a/lib/gen_crc64table.c b/lib/gen_crc64table.c
> index 55e222acd0b8..e05a4230a0a0 100644
> --- a/lib/gen_crc64table.c
> +++ b/lib/gen_crc64table.c
> @@ -15,14 +15,14 @@
>   */
>  #include <inttypes.h>
>  #include <stdio.h>
>
>  #define CRC64_ECMA182_POLY 0x42F0E1EBA9EA3693ULL
> -#define CRC64_ROCKSOFT_POLY 0x9A6C9329AC4BC9B5ULL
> +#define CRC64_NVME_POLY 0x9A6C9329AC4BC9B5ULL
>
>  static uint64_t crc64_table[256] = {0};
> -static uint64_t crc64_rocksoft_table[256] = {0};
> +static uint64_t crc64_nvme_table[256] = {0};
>
>  static void generate_reflected_crc64_table(uint64_t table[256], uint64_t poly)
>  {
>         uint64_t i, j, c, crc;
>
> @@ -80,16 +80,16 @@ static void print_crc64_tables(void)
>         printf("#include <linux/types.h>\n");
>         printf("#include <linux/cache.h>\n\n");
>         printf("static const u64 ____cacheline_aligned crc64table[256] = {\n");
>         output_table(crc64_table);
>
> -       printf("\nstatic const u64 ____cacheline_aligned crc64rocksofttable[256] = {\n");
> -       output_table(crc64_rocksoft_table);
> +       printf("\nstatic const u64 ____cacheline_aligned crc64nvmetable[256] = {\n");
> +       output_table(crc64_nvme_table);
>  }
>
>  int main(int argc, char *argv[])
>  {
>         generate_crc64_table(crc64_table, CRC64_ECMA182_POLY);
> -       generate_reflected_crc64_table(crc64_rocksoft_table, CRC64_ROCKSOFT_POLY);
> +       generate_reflected_crc64_table(crc64_nvme_table, CRC64_NVME_POLY);
>         print_crc64_tables();
>         return 0;
>  }
> --
> 2.48.1
>
