Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B9C36C596
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 10:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765966790; cv=none; b=GxTa7BBGb9peYQXf+6lHofNzQNPxfszm0fE3sPC0D6fFu5J318avd139xf2H0WrTSBFp0dAoHcNvXWe/l///mpLZQ7z6SOZNCYPmfmogPLf3Tz1uipvZFgBK804gndAjrio6Nrlzxknvw/rgyROurCYeG7H2MGTVgb2FoT3Rd1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765966790; c=relaxed/simple;
	bh=xGlRGxtJyc5wWOiXPaKEKso7GdBWsJ8+AfGIMA9gHEw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qKU93mxQdXAB0MToE/ImhxKzdovqO4opSXGcKT25PmQR8evJbBLjMhR91vcUr82ePaa/zGPAwUQrUD9LG0kouXshL7a2/AtsH5nygqO9n08Hw8uN7Dc/He20bv4apTfxGk38l2/z2yvkc5TcCQ9khJnki07S9PCImNMFzIv1U1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SkyZDeso; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SkyZDeso"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8b2ea5a44a9so602251285a.0
        for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 02:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765966787; x=1766571587; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=23gqEg6vrrMOt95UIpPZRnWZYiatBfrUBDzMVbZzD8w=;
        b=SkyZDesogtBIudtdnSTMHh9ORriLhtsS0ZRXoo2sRplWDvN9Q4ifqNpY0JlN842dDB
         nIJ094MZ+nHDVhbew5gUiEnFFz4AgMpdK6jr384NEJ50GrKWyp1wvL9YjK/1TsQdGX2F
         3YRkyvnxeAprHuI82ORjV6k7ZqEr+fp4sIiV3tW76rVd6WF/EBmx7ev2mvq9ZqK9s3U7
         Nsr/dANJoxKxdpCxDwrMIRJO74T+pGDiBxt45QqNgsgBbRipX/f7yL+rEf2JxXLOLVPu
         bHMs3sHQ+WG0ERezMTro6+BQAK+FTCLQ7nJaVuP1gtSSfzbgw1EGuxQUijzh8Z5h4rU7
         7eIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765966787; x=1766571587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=23gqEg6vrrMOt95UIpPZRnWZYiatBfrUBDzMVbZzD8w=;
        b=cdHFKUsp9rvoLQe/K6HUF9FagNh7LDMJ+kJAyCShKW37+02U69P2urDtG0TjoVIuay
         eU/Ns4qDviNerYhx3Dbj3HtVYubrLtwDFL0f88C6jlud8pdWmMd+mzFFpaTybU9823ze
         Hz9x0nLoVRU7r0pw0niqIs1dXbKNUrAK2siF4U8l5+H6y4brHNVscv+vmbkSGstNlF8p
         wATWp0GTlx4JIoW+CO04DAFsd8mzsmKFPeq6ZcFJ0Kq54ntrWkFtFt+PFLm/gmkYOfUF
         89Jc10C1a/3DkpjwmHidEjE1XnDeoWQgNf+IjGeyki2yBZYw9zWzVazHQDX6YdmjVkcC
         Nqlw==
X-Forwarded-Encrypted: i=1; AJvYcCWj22EgG406R4JyJdEI4DSDO4xkxHeht1NhZSp0VQfXyzvBqYwkRdOxSIBCBLQeB9uh6gXCfJdAlRhNS8o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDJPN1maodJvwZQ/jPev2/gyRycrZpxkcIWFLOTWKx/fk+e8Q4
	k1GP0XCBz/2auiQ99s+f9Ouj/re4QamqlyT81DlT8uV93mHzQnuX8qs8z/oRlQJYVfQQkJA5Ao1
	oAN+W9AzYi3e/rvPEm6w3Q51wHfrrFovaZHoH59AY
X-Gm-Gg: AY/fxX5DZYJsDUR4RLfKz22YfeGxqwOvcbf4ahl5jDevJWAVIXi0AJivFawMLIABCE2
	YGeTOqlusG7wHeCcYOevROKFUQdcDBKbnMuWHRX7ApM968uJGY4P0v6UNqkoypLwwKtkfy2OlNj
	0g5sx8N8IMma6QGC+81DywDPIGnkb8R5pQeQkTFQD0ScCsHhJ1pwGoIXRtALgIAtPIxLZjRNFe/
	N0tyFgjBROy40sj0pEFfhzfRVjkdOa606tTGTxjv1YuKPxtDrjDy2h6VFIpuVmOEVrOnb7EbnXF
	PRvdTZV/coLmcfUYDrabO6Ht
X-Google-Smtp-Source: AGHT+IGPDd7JF5alyNhEgjcrVW09ThoKJGuLHl1FsoSDP2QjJlJMFmAXfyQUqSR9tS29F3NlT0wkkL8H1bva58+snIg=
X-Received: by 2002:a05:622a:5c94:b0:4ed:a6b0:5c26 with SMTP id
 d75a77b69052e-4f1d05e102emr259116031cf.58.1765966786794; Wed, 17 Dec 2025
 02:19:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <cbc99cb2-4415-4757-8808-67bf7926fed4@linuxfoundation.org> <CABVgOSkbV0idRzeMmsUEtDo=U5Tzqc116mt_=jqW-xsToec_wQ@mail.gmail.com>
In-Reply-To: <CABVgOSkbV0idRzeMmsUEtDo=U5Tzqc116mt_=jqW-xsToec_wQ@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 17 Dec 2025 11:19:10 +0100
X-Gm-Features: AQt7F2rCVoKiHzMLr5gq2Ln7RdeonRMo17AX2R1_t7knfurC9ARwqPf8_xuG9S0
Message-ID: <CAG_fn=WvdKZgmkqa09kwLLH3P_j6GFYzopeD-PZ-Qt0-1KUaGw@mail.gmail.com>
Subject: Re: [PATCH v3 00/10] KFuzzTest: a new kernel fuzzing framework
To: David Gow <davidgow@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Ethan Graham <ethan.w.s.graham@gmail.com>, 
	andreyknvl@gmail.com, andy@kernel.org, andy.shevchenko@gmail.com, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	dhowells@redhat.com, dvyukov@google.com, elver@google.com, 
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz, 
	jannh@google.com, johannes@sipsolutions.net, kasan-dev@googlegroups.com, 
	kees@kernel.org, kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de, 
	rmoar@google.com, shuah@kernel.org, sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2025 at 10:54=E2=80=AFAM David Gow <davidgow@google.com> wr=
ote:
>
> On Sat, 13 Dec 2025 at 08:07, Shuah Khan <skhan@linuxfoundation.org> wrot=
e:
> >
> > On 12/4/25 07:12, Ethan Graham wrote:
> > > This patch series introduces KFuzzTest, a lightweight framework for
> > > creating in-kernel fuzz targets for internal kernel functions.
> > >
> > > The primary motivation for KFuzzTest is to simplify the fuzzing of
> > > low-level, relatively stateless functions (e.g., data parsers, format
> > > converters) that are difficult to exercise effectively from the sysca=
ll
> > > boundary. It is intended for in-situ fuzzing of kernel code without
> > > requiring that it be built as a separate userspace library or that it=
s
> > > dependencies be stubbed out. Using a simple macro-based API, develope=
rs
> > > can add a new fuzz target with minimal boilerplate code.
> > >
> > > The core design consists of three main parts:
> > > 1. The `FUZZ_TEST(name, struct_type)` and `FUZZ_TEST_SIMPLE(name)`
> > >     macros that allow developers to easily define a fuzz test.
> > > 2. A binary input format that allows a userspace fuzzer to serialize
> > >     complex, pointer-rich C structures into a single buffer.
> > > 3. Metadata for test targets, constraints, and annotations, which is
> > >     emitted into dedicated ELF sections to allow for discovery and
> > >     inspection by userspace tools. These are found in
> > >     ".kfuzztest_{targets, constraints, annotations}".
> > >
> > > As of September 2025, syzkaller supports KFuzzTest targets out of the
> > > box, and without requiring any hand-written descriptions - the fuzz
> > > target and its constraints + annotations are the sole source of truth=
.
> > >
> > > To validate the framework's end-to-end effectiveness, we performed an
> > > experiment by manually introducing an off-by-one buffer over-read int=
o
> > > pkcs7_parse_message, like so:
> > >
> > > - ret =3D asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen);
> > > + ret =3D asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen + 1);
> > >
> > > A syzkaller instance fuzzing the new test_pkcs7_parse_message target
> > > introduced in patch 7 successfully triggered the bug inside of
> > > asn1_ber_decoder in under 30 seconds from a cold start. Similar
> > > experiments on the other new fuzz targets (patches 8-9) also
> > > successfully identified injected bugs, proving that KFuzzTest is
> > > effective when paired with a coverage-guided fuzzing engine.
> > >
> >
> > As discussed at LPC, the tight tie between one single external user-spa=
ce
> > tool isn't something I am in favor of. The reason being, if the userspa=
ce
> > app disappears all this kernel code stays with no way to trigger.
> >
> > Ethan and I discussed at LPC and I asked Ethan to come up with a generi=
c way
> > to trigger the fuzz code that doesn't solely depend on a single users-s=
pace
> > application.
> >
>
> FWIW, the included kfuzztest-bridge utility works fine as a separate,
> in-tree way of triggering the fuzz code. It's definitely not totally
> standalone, but can be useful with some ad-hoc descriptions and piping
> through /dev/urandom or similar. (Personally, I think it'd be a really
> nice way of distributing reproducers.)
>
> The only thing really missing would be having the kfuzztest-bridge
> interface descriptions available (or, ideally, autogenerated somehow).
> Maybe a simple wrapper to run it in a loop as a super-basic
> (non-guided) fuzzer, if you wanted to be fancy.
>
> -- David

An alternative Ethan and I discussed was implementing only
FUZZ_TEST_SIMPLE for the initial commit.
It wouldn't even need the bridge tool, because the inputs are
unstructured, and triggering them would involve running `head -c N
/dev/urandom > /sys/kernel/debug/kfuzztest/TEST_NAME/input_simple`
This won't let us pass complex data structures from the userspace, but
we can revisit that when there's an actual demand for it.
