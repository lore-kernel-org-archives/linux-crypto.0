Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22ED34B192
	for <linux-crypto@vger.kernel.org>; Fri, 10 Apr 2026 10:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775815902; cv=none; b=eeXQYwqcb8djRdbvWsvmX/BbpErIZ8NBycT/t/WAcV9ZF6qPrepjaPv7ELLC0zAS4i7FE3NS/M15HQTTeo761yRUIsSCK8pYDDEbrwsaT0UMcWGpo43d2x0cvfrrjN9SwtzkIcY/fPApr+8mXWF/lWcKi91h5gXV8FpeY2gFaS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775815902; c=relaxed/simple;
	bh=fIJwh5BFSH7dCiP0sH7Mjk/N9zyIdDIChiZWQXC901s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uabP8R/1btGtM028P0ZXnRwlRBRJl6bXXybhmjUoWQPNcA+37FfXiXbKprB9e3inxHREDM2e360dyyh0Ek4RDJkUbVWLBYaSwRVPV2Tmp3FieYC689AINNOSajg6AJ8qoBk5lu0mByUhv/BJpZK/njqOWKO1nX0LwNnMFDTpKkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DIlNN/p7; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DIlNN/p7"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4887f49ec5aso22648715e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 10 Apr 2026 03:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775815899; x=1776420699; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vriq12r4o7DH3L9OJr2Nl0craSSQV9b/VgMNVUn19d0=;
        b=DIlNN/p7T/5eBRpaEeeb+8eE3xqhG0fcMOYmx6it+lOzdNiOxhqyHSox6R9ojhsJq5
         5ZTs73Adig2wG5Yl4xEI3QSS60QVL+aFvPRI2vBIrpcj58EH5TiQyCryfK36corfalrc
         QIv7uA8OdQtt2gJowwG1HMRO6Ic/+7x80S2h0vWio+N7ji5CsRIAZQG0oSFr4yTSSlXg
         BIbMPvUomgHVwEvNnK/5nEgyfcuLFz9Oh7V6Ueoo2LFIXs7AZTQJfcGYfGVF3wK0vE2l
         fuwpZ+oNGS8kkpp3kP/llxaYsRR/uCzRBXZJc27qAUCbtGprRcTg+a2REjvFN+Zn5xMZ
         hJKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775815899; x=1776420699;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vriq12r4o7DH3L9OJr2Nl0craSSQV9b/VgMNVUn19d0=;
        b=I3vYx8qPUDv1x0tG6+Ym3Jm96abl7N1k7jP8t6oKQ0Zq9c2ImT9obGrBJ5EmJpoQ4q
         i7BwNU0OgmrUB3fmlR8bkLie7J7dWbj/nyQ1Sire1c9ejbxpzWuUwx1lryT3dE89YI9h
         ax7UJ/ZjHHNBbzsykvNiHG4K9kEH2uJ+16T+bnX79CJXhkOv6Fh5iGrK30VVbsJq0B/Q
         9WznqtQollMgTe3OtJUv8DAeYLkREhWAv1wnTOajsc2sYb5s1iGfepbqbD0CAth+ZvOj
         ANPanbwE8gpEkPfmd0d2Mpv4q0A0Sfn9oI1Xia3xe31PPRNb8lxYdbzH5CH+pM65JjDh
         En5w==
X-Gm-Message-State: AOJu0Yw11Gkmnf5yq9m18jeaQdm8rrG3Kz+VCkUTAuiJCaMPToW5N0Gi
	Im86kgq0hao2tXHqAbMgo2UC20G6SA6uuKnMP6WDniYwg8ovsVLYq+oX7l2+OQ==
X-Gm-Gg: AeBDiesCE8+qqKspqwM6i/rvgeA/SL/vIkef0fSgC5HJj47EK+ttmu23gt42kDTi9kf
	By5DQiM11eRYoy1iqDeZrrIVc5klUEfnVMXXkJzHH6Xu2QY8wc885Sqn9IGkhmtLU1Fl+mow2/k
	LBEDoBPVFcmWoAgbonAVmw6K6Dv1K3S9oTeNEko+sBgGLhOhY5nUmZ6SCIYVIem2E/weUWH8Msv
	rzbb2CpkP8Ig8h90lhZQrMsUmL6w3mcO54b3/FSsNGsJGa8aYBAQM7uXeExkwz2VpbSCOoTBFcq
	jjoIRIy2JLcwjGFziuFk0Prg+2SPDrOch1fJKX1pJ7Jv0v74sFel7ilzwO6m6wr11KAF9QrxXtQ
	MSzueE6Sy50xjRaryWu+TRT4E6Vk3IN4dZFBMiZ9DKT+rOj7K9pgCvH1GmQj2TL+0TDI9rUIxYI
	jt+5u0eqJn6WF6z9tVIkk=
X-Received: by 2002:a05:600c:820a:b0:488:b675:360f with SMTP id 5b1f17b1804b1-488d6889a6bmr27992505e9.27.1775815899149;
        Fri, 10 Apr 2026 03:11:39 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488cd10b1dbsm94096115e9.2.2026.04.10.03.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 03:11:38 -0700 (PDT)
Date: Fri, 10 Apr 2026 13:11:35 +0300
From: Dan Carpenter <error27@gmail.com>
To: Lukas Wunner <lukas@wunner.de>
Cc: linux-crypto@vger.kernel.org
Subject: [bug report] crypto: rsassa-pkcs1 - Migrate to sig_alg backend
Message-ID: <adjM11LyVuGJwy16@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Lukas Wunner,

Commit 1e562deacecc ("crypto: rsassa-pkcs1 - Migrate to sig_alg
backend") from Sep 10, 2024 (linux-next), leads to the following
Smatch static checker warning:

	crypto/rsassa-pkcs1.c:193 rsassa_pkcs1_sign()
	warn: check that subtract can't underflow 'ps_end - 1' '0-4294967293'

crypto/rsassa-pkcs1.c
    158 static int rsassa_pkcs1_sign(struct crypto_sig *tfm,
    159                              const void *src, unsigned int slen,
    160                              void *dst, unsigned int dlen)
    161 {
    162         struct sig_instance *inst = sig_alg_instance(tfm);
    163         struct rsassa_pkcs1_inst_ctx *ictx = sig_instance_ctx(inst);
    164         const struct hash_prefix *hash_prefix = ictx->hash_prefix;
    165         struct rsassa_pkcs1_ctx *ctx = crypto_sig_ctx(tfm);
    166         unsigned int pad_len;
    167         unsigned int ps_end;
    168         unsigned int len;
    169         u8 *in_buf;
    170         int err;
    171 
    172         if (!ctx->key_size)

Could this be a check for if (ctx->key_size < 11) instead?

    173                 return -EINVAL;
    174 
    175         if (dlen < ctx->key_size)
    176                 return -EOVERFLOW;
    177 
    178         if (rsassa_pkcs1_invalid_hash_len(slen, hash_prefix))
    179                 return -EINVAL;
    180 
    181         if (slen + hash_prefix->size > ctx->key_size - 11)
    182                 return -EOVERFLOW;
    183 
    184         pad_len = ctx->key_size - slen - hash_prefix->size - 1;
    185 
    186         /* RFC 8017 sec 8.2.1 step 1 - EMSA-PKCS1-v1_5 encoding generation */
    187         in_buf = dst;
    188         memmove(in_buf + pad_len + hash_prefix->size, src, slen);
    189         memcpy(in_buf + pad_len, hash_prefix->data, hash_prefix->size);
    190 
    191         ps_end = pad_len - 1;
    192         in_buf[0] = 0x01;
--> 193         memset(in_buf + 1, 0xff, ps_end - 1);

Smatch thinks ps_end could be zero.

    194         in_buf[ps_end] = 0x00;
    195 
    196 

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter
