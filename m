Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C770B39901E
	for <linux-crypto@vger.kernel.org>; Wed, 14 Jan 2026 12:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768393732; cv=none; b=d7hxBPceyI6B+2OUpqi/S/23YegwzdwGcVuDtL1dm1dA7n86VpujW+WTu3IGAEZh/9kszYuOev0Q96wqCPzU+gO6Eyz+cDXL5ps6pDNy1jYsUgeZeZ4ZhNiCRiyi+9VT/5yvTRJar8sHuZOT0LFEmwPVZVyBwThSM49NCIh6J+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768393732; c=relaxed/simple;
	bh=YtR0Szmeb+TLQ6rU4/M/KcRSwxHD4rJvyR6KfeHdxmo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B/3aQEWa/YU2n+cqN7uluIc5Vs2Nn1R3Qh9hqKshjT5bqd4PgvtBiZuhvFy1ANNedYXvPOTD+N/HosYXO0IZWIDTC/NQC7+eYVFt+DmCpOjf4hqMNEdP9gHtXUAKaUc3yNkTvNR/smgKP/6yU6SlvwLqdrKmVU7iq/JTupv7f2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O9Oe5Idr; arc=none smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O9Oe5Idr"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-121bf277922so10403517c88.0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jan 2026 04:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768393730; x=1768998530; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LRMIFkzXb5IBhiTKdWbjWhp1Z2C8Xy7d3z7GyFAcX9o=;
        b=O9Oe5IdrgxvG44bzVUdRjBkk+jHngSDeDbuiuK+k5L3ZUJHT4/fhVDJAjhLCYgeakL
         cYEY2A364+JW26oCw+NfgjTrroqy/hYlVvdPFVgNdKa1VrIYBDtcdHyAD9Uh13CMyhzj
         O8pYBfJ8uYZsGX9A9d+ZL622GDQl0mRZ+02iUMrSIbH6gO77xoPfvFR65tozhb5dBTF+
         KecxJmlCZCAEwKNjUCdvXl3v15vb/QZJ6gkE6jczAIQCIqUsauHAli1J8k+YKOS6RRlJ
         tMHgyRGvCv5VRlEfgbdkgpMSS4v6F1L3gJYIZ2vCgK2J37S9LTBjEJeQ0CKkpKpBYL4U
         6dUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768393730; x=1768998530;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LRMIFkzXb5IBhiTKdWbjWhp1Z2C8Xy7d3z7GyFAcX9o=;
        b=JCYkDGCRj8ZOxOYn2nEQxZEcu2Puxfdi29u25tIblM1AkBttIVXV6ydHRNn+jDSHyZ
         etlR/4tFicOyi4Tbd2Q2+/1ifyMI9DgEVbej9niIrX5tbqEwrv4n7TOsCW9j9BdoP4GQ
         b/1GawAXqhDlBsIcBn00IDKeZul3TTGW+7c8pShJxeKFTj7QRuQJydjQL+TAzU2BSvzm
         sP9OgToEp7KZF0kuykBLxUXk4aCeqBGEVesuN2O/rahT4+WyQdj7CYWNw9gTev8LlFfS
         s92Dbbnvlof9nq2NsMXMm/HVYMe+JmpSsgTU2MPdsD0NSh058gNkoW3rfXuNao0360GR
         4W/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWVvHxCLXaoJe5bRCCqhkw61uzs7FEljE4E0OjjQCX0oWSieJuDIeZujdkKNh2/fDCKjcR628TApMRqfwI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4cxM3JFoe8Fv1xQNU4XQLYTKp/wFDMUgdiH8FVvf2lqhMUD/6
	HBX3sBZ+y8ll2btre/89jAuGPdK3CjUp8yu13KHcrxu23fLK3j8UENGWTCDHUmNAHa5houS1HfR
	H2Y3NEXG+HdP3VkDEMenSk+o8UtVJqWw=
X-Gm-Gg: AY/fxX5Rg16Hg9ECiDWf74kKX9cHOwXUY1oM1MtKGKB7De8u+0r53gjrEHsNTLVQS8R
	hqUy6Jk7DYroyNwpZsWRdL3b7ENZNeRBS/5ZZxRppRsNHY+8XYleJnDeWRCTmULhp08QVRLQ7kG
	3hqIw1P+GOLVlimC/7taDHo32ZeBQiVdx9h4ToCsAOf7ziKxiTp+jNTw283iqnyxMnfetJckuUa
	H7k606SY4MhWFC/Y6G9tf8uKLcN/PyOsW77ZtX39M6Nc9unPokibwQXSto3MqUxRxEdEYEZ3C0O
	PtmU9q3IeXNxlcbtzyfWEXQ/
X-Received: by 2002:a05:701b:231a:b0:11d:f440:b757 with SMTP id
 a92af1059eb24-12336a8ac7cmr2122254c88.26.1768393729717; Wed, 14 Jan 2026
 04:28:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
In-Reply-To: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
From: Ethan Graham <ethan.w.s.graham@gmail.com>
Date: Wed, 14 Jan 2026 13:28:38 +0100
X-Gm-Features: AZwV_QgmF4HyCsXk2jh6zEFc90ih1bVBX_Jk6twBkZMZEi05K-WZZcMS9j7S7Fc
Message-ID: <CANgxf6yGDGAD9VCqZyqJ8__dqHOk-ywfSdhXL5qATfxnT-QGFA@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] KFuzzTest: a new kernel fuzzing framework
To: ethan.w.s.graham@gmail.com, glider@google.com
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy@kernel.org, 
	andy.shevchenko@gmail.com, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, ebiggers@kernel.org, elver@google.com, 
	gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, mcgrof@kernel.org, shuah@kernel.org, 
	sj@kernel.org, skhan@linuxfoundation.org, tarasmadan@google.com, 
	wentaoz5@illinois.edu, raemoar63@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Johannes,

I wanted to check if this v4 aligns with your previous feedback regarding
the tight coupling with userspace tools.

The custom serialization has been removed entirely along with the bridge
tool. This series now focuses exclusively on passing raw binary inputs
via debugfs with the FUZZ_TEST_SIMPLE macro.

The decoupling eliminates any dependency on syzkaller and should help
remove some of the blockers that you previously encountered when
considering integration with other fuzzing engines.

Does this simplified design look closer to what you need?

Thanks,
Ethan

On Mon, Jan 12, 2026 at 8:28=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> This patch series introduces KFuzzTest, a lightweight framework for
> creating in-kernel fuzz targets for internal kernel functions.
>
> The primary motivation for KFuzzTest is to simplify the fuzzing of
> low-level, relatively stateless functions (e.g., data parsers, format
> converters) that are difficult to exercise effectively from the syscall
> boundary. It is intended for in-situ fuzzing of kernel code without
> requiring that it be built as a separate userspace library or that its
> dependencies be stubbed out.
>
> Following feedback from the Linux Plumbers Conference and mailing list
> discussions, this version of the framework has been significantly
> simplified. It now focuses exclusively on handling raw binary inputs,
> removing the complexity of the custom serialization format and DWARF
> parsing found in previous iterations.
>
> The core design consists of two main parts:
> 1. The `FUZZ_TEST_SIMPLE(name)` macro, which allows developers to define
>    a fuzz test that accepts a buffer and its length.
> 2. A simplified debugfs interface that allows userspace fuzzers (or
>    simple command-line tools) to pass raw binary blobs directly to the
>    target function.
>
> To validate the framework's end-to-end effectiveness, we performed an
> experiment by manually introducing an off-by-one buffer over-read into
> pkcs7_parse_message, like so:
>
> - ret =3D asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen);
> + ret =3D asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen + 1);
>
> A syzkaller instance fuzzing the new test_pkcs7_parse_message target
> introduced in patch 7 successfully triggered the bug inside of
> asn1_ber_decoder in under 30 seconds from a cold start. Similar
> experiments on the other new fuzz targets (patches 8-9) also
> successfully identified injected bugs, proving that KFuzzTest is
> effective when paired with a coverage-guided fuzzing engine.
>
> This patch series is structured as follows:
> - Patch 1 introduces the core KFuzzTest API, including the main
>   FUZZ_TEST_SIMPLE macro.
> - Patch 2 adds the runtime implementation for the framework
> - Patch 3 adds documentation.
> - Patch 4 provides sample fuzz targets.
> - Patch 5 defines fuzz targets for several functions in crypto/.
> - Patch 6 adds maintainer information for KFuzzTest.
>
> Changes since PR v3:
> - Major simplification of the architecture, removing the complex
>   `FUZZ_TEST` macro, the custom serialization format, domain
>   constraints, annotations, and associated DWARF metadata regions.
> - The framework now only supports `FUZZ_TEST_SIMPLE` targets, which
>   accept raw binary data.
> - Removed the userspace bridge tool as it is no longer required for
>   serializing inputs.
> - Updated documentation and samples to reflect the "simple-only"
>   approach.
>
> Ethan Graham (6):
>   kfuzztest: add user-facing API and data structures
>   kfuzztest: implement core module and input processing
>   kfuzztest: add ReST documentation
>   kfuzztest: add KFuzzTest sample fuzz targets
>   crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
>   MAINTAINERS: add maintainer information for KFuzzTest
>
>  Documentation/dev-tools/index.rst             |   1 +
>  Documentation/dev-tools/kfuzztest.rst         | 152 ++++++++++++++++++
>  MAINTAINERS                                   |   7 +
>  crypto/asymmetric_keys/Makefile               |   2 +
>  crypto/asymmetric_keys/tests/Makefile         |   4 +
>  crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    |  18 +++
>  .../asymmetric_keys/tests/rsa_helper_kfuzz.c  |  24 +++
>  include/asm-generic/vmlinux.lds.h             |  14 +-
>  include/linux/kfuzztest.h                     |  90 +++++++++++
>  lib/Kconfig.debug                             |   1 +
>  lib/Makefile                                  |   2 +
>  lib/kfuzztest/Kconfig                         |  16 ++
>  lib/kfuzztest/Makefile                        |   4 +
>  lib/kfuzztest/input.c                         |  47 ++++++
>  lib/kfuzztest/main.c                          | 142 ++++++++++++++++
>  samples/Kconfig                               |   7 +
>  samples/Makefile                              |   1 +
>  samples/kfuzztest/Makefile                    |   3 +
>  samples/kfuzztest/underflow_on_buffer.c       |  52 ++++++
>  19 files changed, 586 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/dev-tools/kfuzztest.rst
>  create mode 100644 crypto/asymmetric_keys/tests/Makefile
>  create mode 100644 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
>  create mode 100644 crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
>  create mode 100644 include/linux/kfuzztest.h
>  create mode 100644 lib/kfuzztest/Kconfig
>  create mode 100644 lib/kfuzztest/Makefile
>  create mode 100644 lib/kfuzztest/input.c
>  create mode 100644 lib/kfuzztest/main.c
>  create mode 100644 samples/kfuzztest/Makefile
>  create mode 100644 samples/kfuzztest/underflow_on_buffer.c
>
> --
> 2.51.0
>
