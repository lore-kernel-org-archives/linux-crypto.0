Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C794D2BD015
	for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 13:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758030216; cv=none; b=T/Wdgu2U0xVkDkvG9ogzlumEt3Y3Az1jKkWCqwJee/LbfCcdkbME+EAPT3fZGzDIuFLIsLzF/qDUuxP6QombZAVWhkggFyJU5Iz6we1VffT/AwSz30JXg6S0xzyJDY4e4wyRt4OLBB9c7LjdioeMjmhgqlgQZ0wX5/dLnBvK64o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758030216; c=relaxed/simple;
	bh=XWPXPFwYPgFopfyxu3zdVrQPwiTk6AP3tAMpPe1ARK0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HWAZJht1mYCNf4eYhRB1lmHWTg3RXjnM4/3+F4fzJ9FnKaooFSjxUHVY5Og82ZtLRXY5MMo2YjN8E+id5IPQ/0rIh11XO6qXhQDyptFkK+n9soPEKrI1guadhTM3MUBh5byIxCnK7UfBuutVxjAjiPuvGr5hdLLg0FuAWB82hPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JZQA0uWb; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JZQA0uWb"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-776aee67e8dso16622506d6.3
        for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 06:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758030214; x=1758635014; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WFMguP23bZIISRu8P8L8i4YMMkZ2fq1VcnZsxEVckmk=;
        b=JZQA0uWbAebE9uTtErpjBQmOiUOvBHKv9zZQql83gbMxXatkIvd7+iIe8bc386M0ZZ
         RCq+tmKhP4feCvsvUL6eEV8Do5jppsERIGDLmWPVwrwenHkt8PGPgIfNe0qxwsdbiJBW
         RWYhCDmzO3wyvTBNEcb7yNtKhghpPS9PMZvYsackg2jpv35SPsw+3s5WlBvZ6vUE4lOR
         iFvgEc+i78nYmIJZRcD36X7GXz29PxdpBmteFV7TgdkayvutWfCWE5HKJEEZT/kw5CYT
         bCueslyFoutPm3bqeHRtM9ouK595Yiy2bxmmDtxER4DNJHKIOwx7Xhs3qXesvs5/WMLQ
         eFYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758030214; x=1758635014;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WFMguP23bZIISRu8P8L8i4YMMkZ2fq1VcnZsxEVckmk=;
        b=uNcnCe/JRc/m7vzEEcUlef1oK7gtMHEEkPylTpLC4CnctM6QoVrCJ+X5i/8uRY99RH
         lLXC9zBtKV23Jz4NTirq+vVbeYT6eZa2wOnM7ur5b7yklgSuNybXM4Iql6xxhAwkE+wK
         jpc29fysF/rJUhak0n4yqwkBsQgzdKbiLCDL3CU0J9Yxzvrtg1wkUl7fyUYhF3BbkLEi
         UFTksX65VcPxnu5rhBhNRQ5MLu/HX3CX0KcNofNzpsUOAEYAUbOXc6kfEdB5jpnRwK58
         mhFheN7m2x2ODrc5u1TN2EEHM6lCBBuShSIcUa9QqBWBQtRygG8xBJ9u7dj9ijZACtay
         pYDg==
X-Forwarded-Encrypted: i=1; AJvYcCV70cM2UAmc5HpOvPFXqHZGXNjqHEH8yrNW9aYWcKsq2T9dQkA3Ur/HoDvG80EK94EFpUcBA38wHI7vcW0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9BYOg/aXFjnt1E97iLxBXzjaZuK2NhqvwGuifqlzRkMpcFLGs
	3YfO91V9Or/1K9qc4ZjQ0X3aAPk6S0kK6u3U68SZKT8HLJi7W9EJ7zfE12poQGRLWxStm1inQJY
	o5f5QXXwZPD1bEbAZs92EP8T4nZP1ym3v76xCkE3S
X-Gm-Gg: ASbGncvB+A8tAqaS2MUiBa8huiGFdcyVajIO2ouh2AhaSW0GcV6krsiPRPGEx5rR6YU
	JGURLgOmVqWxYuvee1rlfuvnfclTk/o1A6ub6q/hvOubgIqDpYxRFZf5JoPmn7tx+iM8tCDGCfm
	gJjz1rNLZKJAgU2x8W9c0rXmhrLvujKAbagwrJM/PeERqrx14Vc7cWq5KoZJDVoD6GN9rcAWVVK
	/B3DZ2Ly3fIwpN+R3okGDnhys1nZJHe04gxOKISrMWV
X-Google-Smtp-Source: AGHT+IFhDI3DiXQjQ2M/pDauu4pj8WaE92jep/q+QEEg6eNCMk/WVoS5e7N/U3EzJP+zE2T6dly3yK42LO8dPZ3MnPk=
X-Received: by 2002:a05:6214:2624:b0:71c:53c0:5674 with SMTP id
 6a1803df08f44-767bb3b5cc7mr189377726d6.7.1758030212716; Tue, 16 Sep 2025
 06:43:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com> <20250916090109.91132-5-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250916090109.91132-5-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 16 Sep 2025 15:42:55 +0200
X-Gm-Features: AS18NWDFPFWnjGnn0Ya31_ptvZRyrk4s5Sg6fkIlAJtVA6vYI3uU8Zv2xeIdCLw
Message-ID: <CAG_fn=UJsV1ibxSf6D+QU4ds1mHUG77NWJ5TR3sVs3f696RgiA@mail.gmail.com>
Subject: Re: [PATCH v1 04/10] tools: add kfuzztest-bridge utility
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"

> ---
> v3:

Please change the version number to something like "RFC v3" (here and
in other patches)


> +
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
> +               fprintf(stderr, "tokenization failed: %s\n", strerror(-err));
> +               return err;
> +       }

You should be freeing `tokens` somewhere.

> +
> +       err = parse(tokens, num_tokens, &ast_prog);
> +       if (err) {
> +               fprintf(stderr, "parsing failed: %s\n", strerror(-err));
> +               return err;
> +       }
> +
> +       rs = new_rand_stream(input_filepath, 1024);

You need to bail out here if `rs` is NULL, otherwise encode() will crash.

> +       err = encode(ast_prog, rs, &num_bytes, &bb);

`ast_prog` also needs to be freed at the end of this function.

> +int main(int argc, char *argv[])
> +{
> +       if (argc != 4) {
> +               printf("Usage: %s <input-description> <fuzz-target-name> <input-file>\n", argv[0]);
> +               printf("For more detailed information see /Documentation/dev-tools/kfuzztest.rst\n");

This should be Documentation/dev-tools/kfuzztest.rst without the leading slash.

> +static int read_minalign(struct encoder_ctx *ctx)
> +{
> +       const char *minalign_file = "/sys/kernel/debug/kfuzztest/_config/minalign";
> +       char buffer[64 + 1];
> +       int count = 0;
> +       int ret = 0;
> +
> +       FILE *f = fopen(minalign_file, "r");
> +       if (!f)
> +               return -ENOENT;
> +
> +       while (fread(&buffer[count++], 1, 1, f) == 1)
> +               ;

What's the point of this loop, why can't you read sizeof(buffer)-1
bytes instead?
(note that the loop also does not validate the buffer size when reading).

> +       buffer[count] = '\0';
> +
> +       /*
> +        * atoi returns 0 on error. Since we expect a strictly positive
> +        * minalign value on all architectures, a return value of 0 represents
> +        * a failure.
> +        */
> +       ret = atoi(buffer);
> +       if (!ret) {
> +               fclose(f);
> +               return -EINVAL;
> +       }
> +       ctx->minalign = atoi(buffer);

Why are you calling atoi() twice?


> +       ret = malloc(sizeof(*ret));
> +       if (!ret)
> +               return -ENOMEM;
> +       ret->type = NODE_LENGTH;
> +       ret->data.length.length_of = strndup(len->data.identifier.start, len->data.identifier.length);

This strndup() call may fail.


> +       if (!consume(p, TOKEN_RBRACE, "expected '}'") || !consume(p, TOKEN_SEMICOLON, "expected ';'")) {
> +               err = -EINVAL;
> +               goto fail;
> +       }
> +
> +       ret->type = NODE_REGION;
> +       *node_ret = ret;
> +       return 0;
> +
> +fail:

parse_type() may allocate strings using strndup(), which also need to
be cleaned up here.
