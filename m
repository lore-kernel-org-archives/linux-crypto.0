Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADA42E2F08
	for <linux-crypto@vger.kernel.org>; Fri,  5 Sep 2025 10:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757069065; cv=none; b=h3jhc95t8fsSJSYaDrcvABH3/LjkVQAM40aF55+g5RUnPpJhoLfyD8dqMOk7EbFLc65VhYQurXlCBPPDYK3l78ba2O5JSwAzDh7vV2jtorLWwwza/cDLvZti447ktIwVtk2IhDocGhEGVVH8WxCtgbXJHAGvOGAW3I58qnCbdug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757069065; c=relaxed/simple;
	bh=NtnJqjXAorb15shsffdIRrs7Ou3F++wwVVUu2U2mphg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RdlxfxEP4QBuVQsS23nCJF6zcz8phqYhNlAcuKhxxKn7aAqo8chmDuxhw+yatrvJWbaGNceDfKeJ+arr98I1GPU3uYE61B7eFoaBOMhscuAV1uTvk8f7rWXVKHzZpm6DEVMRe9A7gdX7D4sYITIrjA9ICm+VAMw4juI3JmBve/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HhxCNTo2; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HhxCNTo2"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-7282a09a72aso15755576d6.1
        for <linux-crypto@vger.kernel.org>; Fri, 05 Sep 2025 03:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757069062; x=1757673862; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tJ18ogS6OfuTP1EQiRfSY6yIXK3vsX3youWzsSBm03k=;
        b=HhxCNTo2H8uKzqXAwJJERo78tpmIdSJPA2NlgA5GcPfZGz+2hvXRqV376w3Hs9fLj/
         EcPpQiW6W6TGzXl7xIcgsvNcXNDFja1bHyX0CIi7HKNl2Kt2HNBY35JDaHmkX4sR5xrW
         hFSh/dMoAiE/fMn+5jFwJmgpXd9/fxhsHZWMdpXsqOWss5obtS9qSXGbDcMdpkLm7m6t
         HyPB9oNpxs04ISRKu44eZVUFJmFKc8ypbzsddDpcRlP4tfSSBRX2/PNXj6bD7MMNxC4e
         2Xf+2wUanUCFpgf4hi1H9GYrjYbeHLSWAJ/MCOER2OdIs0P7AkUT4/cycHepJhO/nIyg
         XVuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757069062; x=1757673862;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tJ18ogS6OfuTP1EQiRfSY6yIXK3vsX3youWzsSBm03k=;
        b=gDl28FHBT8ev/l5jiiPLho9HehRw7SRxpLVfnxg9u1kXJMWXaJ8d965NKl02lVjNxZ
         FyrpnZVr8NMx2+ldeKUNk/ItxHIhjzUoE5WFNgclUjTcic/rywc2zBGcPs834Ss+PqB+
         RVp8eH2t2vBR+Q4KueZhPvzAQZmw9uAwhJbHcsWr9aLoT16kHHuwR48au3dvPgxPm1sg
         37Sb48tKP6LgrmRQpyqu+F3lL96vXZWxN3DhR4Pabkf9HpAbXiGj9kMy/Rirzo1e2be7
         i3uY/cNvUhP41kTO6qIT5/2BCt7RhdrcrVrO1I09WFc4eVKEImj8FftU86imjXtNOS1a
         mNPw==
X-Forwarded-Encrypted: i=1; AJvYcCVnkPcOdf4CJgfVzBoW/dvG8Wuw7bGRw2Pep1tqos1kQ2wQSdLcgsNyYmbXRN5Z4Y1H5h5vU5k1OKo4sng=@vger.kernel.org
X-Gm-Message-State: AOJu0YwG8yNi5MD2grxh3/t0BAXLYzoXc/ICiwB9CMa/b0ngMf9+3BTL
	Ouc8SQq/A+9SQImJdm2anAIOsflS6gQSaFN1SrBWvmSUqtO37rk246S5LssBgmr5uVQGsCZ1bLL
	PtzgFiIzESLZgrNpWlKRAVLG/+P0Yafwqd1LAMn/8
X-Gm-Gg: ASbGncvDfJoaoHX2bz9xAYdf6pGbwWyxnsTrDoPTL7xAX5Avl0hTff7m+f2mg/pJw55
	zk1GZJcsPIrDdomU4a9MwAt1Dc8HRwd3iCIETGaE3Cb8Nec4B60a+VXUU+gTyQbLQLdCFO8hFdc
	4z8ecY4QXqgOsOKvd1cXA5N3QuYm0SlpQ+brqCQDKuhHyZ6cU16k5liij5hnJl/nAbwHI8b91BX
	SO4caG6D2zp7+0n682q4Lh7EYR1e3Y3+YkjJISllGvleR5K2ehvGAXyS2V32cydNg==
X-Google-Smtp-Source: AGHT+IFgnVn5YPd7nt++mcxJYKI5s6CE63gp8oAepp7Bb2RS8fbxpyACzBXy7jLF8rTFHvYVBXrZq9tFnSqmoPRojvg=
X-Received: by 2002:a05:6214:23c7:b0:70b:a189:a571 with SMTP id
 6a1803df08f44-70fac7a01cdmr71754206d6.25.1757069062247; Fri, 05 Sep 2025
 03:44:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com> <20250901164212.460229-5-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250901164212.460229-5-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 5 Sep 2025 12:43:45 +0200
X-Gm-Features: Ac12FXwrVWcwse0FO0oj90oXgii4UalASzAKNOgq4n0I9KmYMeRdWc12CPAmKB4
Message-ID: <CAG_fn=VXxaGd4QC0jHzwFg88HuaOFV4K+_tdzrhqW+UoTk-L6Q@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 4/7] tools: add kfuzztest-bridge utility
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, elver@google.com, 
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> +static int invoke_kfuzztest_target(const char *target_name, const char *data, size_t data_size)
> +{
> +       ssize_t bytes_written;
> +       char buf[256];

I think malloc() is better here.

> +       int ret;
> +       int fd;
> +
> +       ret = snprintf(buf, sizeof(buf), "/sys/kernel/debug/kfuzztest/%s/input", target_name);
> +       if (ret < 0)
> +               return ret;

Please also check that the file name wasn't truncated (ret >= sizeof(buf)).

> +
> +       fd = openat(AT_FDCWD, buf, O_WRONLY, 0);
> +       if (fd < 0)
> +               return fd;
> +
> +       bytes_written = write(fd, (void *)data, data_size);

Not casting data to void * should be just as fine.


> +static int invoke_one(const char *input_fmt, const char *fuzz_target, const char *input_filepath)
> +{
> +       struct ast_node *ast_prog;
> +       struct byte_buffer *bb;
> +       struct rand_stream *rs;
> +       struct token **tokens;
> +       size_t num_tokens;
> +       size_t num_bytes;
> +       int err;
> +
> +       err = tokenize(input_fmt, &tokens, &num_tokens);
> +       if (err) {
> +               printf("tokenization failed: %s\n", strerror(-err));

Please use fprintf(stderr) for errors.


> +static int refill(struct rand_stream *rs)
> +{
> +       size_t ret = fread(rs->buffer, sizeof(char), rs->buffer_size, rs->source);
> +       rs->buffer_pos = 0;
> +       if (ret != rs->buffer_size)
> +               return -1;
> +       return 0;

Note that ret may be less than rs->buffer_size if there's an EOF.
Keeping in mind the possibility to pass files on disk to the tool, you
should probably handle EOF here (e.g. introduce another variable for
the actual data size).
