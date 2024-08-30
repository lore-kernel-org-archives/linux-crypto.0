Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F7013A261
	for <linux-crypto@vger.kernel.org>; Fri, 30 Aug 2024 09:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725010785; cv=none; b=iF0WaEnMqyIMMEYhluPs2079WqtbvTmvfAkx2jPJ2nhb0sEyrb3RTukt7cu4qloLM5dwhczEQkGbqT+mqyYcwP6SN0UzL2UrSHilU5Gb5dmRjgd3dpntiRUMXDgRZNueRRG99iHfZQihjtoG752F0zHPsYsihQFYTDDSxL9b0OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725010785; c=relaxed/simple;
	bh=Vn8kTjaiavDdyc8/wlZpxrXePEbx3gjEURKJpd8Gq8k=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Re5yqTJ/gpjF6axor6XIN0j5giAR4bErvczA2tqsou1FaTOiPvS2r4rG7i3IMj9QaZA9MAbdn8rQV/HE6Ral/5l7DwWFLlHEBgQFf1S0tutCnNdxnbzKa0Za8nQEKzpA0HgN2psKG5ELiP4ML3YiLVALCyP4lPQcEMfx30UCyto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-824d69be8f7so187186739f.0
        for <linux-crypto@vger.kernel.org>; Fri, 30 Aug 2024 02:39:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725010783; x=1725615583;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vn8kTjaiavDdyc8/wlZpxrXePEbx3gjEURKJpd8Gq8k=;
        b=lkQcXgK6vpMRNDf7BNoZ6X5qgRdnP57wEMhC8xi7VP8J4YEWovdK7IDkDRyaQ6GReV
         AtP9dT75xixa96Z3iIpeoU61LGpzuX9rTTh9/D9mjkmD5t2e81sFQ/xXPr/cMnQQA6C6
         mXQ/FvT3mm08v5Ore8QvgLcozfUnOwIFfu0hx0HXucMBcvHK64RgSiLzHxUU6h7EQUSk
         a/Ys1cKqZAsb3yvteIIcT23u1izI2fCRzwufL4qmvmxLTiqkeFBGNVomamcJqFJ6AFWZ
         lszdVwCP8HJvljiq+HCgqq5K0ZSmIN8LIa8iCrD2I6QZ0+HZiGX0jLDCaoImV6cP1Vgg
         UWNw==
X-Forwarded-Encrypted: i=1; AJvYcCXKvdlJQRo94VG1vv/3P/y5Ol7wdOA66V2BLsKwYDrh6c+YsxHq7L4Kj+/HwPrhh1HlwiK3qfzM7cXgJs8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLk8lQQqVoFgNxV2RQ0tZTHRRlE73bX9LKPiyc4DH8l986Wv1c
	j9JZEGSavCqzMz7Qzbo/qNX3ABHlIAenexrVIq4BoDjQ1DbqBZEz5KyIC1+YGXPSJ2KuKfVHTj9
	ygSCqg8ipTgrHlBgc5EuFwivwwPIHntbmpIUgZOJPhwxOLt9o1EzdEkY=
X-Google-Smtp-Source: AGHT+IE+8vcK482ksPdr2S3cq571+SISrzfra5xDCpTzAPln10mLPsgm22zB47bjdTx76XcKpDFbaqhLoqe6LmDioreScin9Ifg1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3494:b0:4c0:a8a5:81cc with SMTP id
 8926c6da1cb9f-4d017e6f688mr49757173.3.1725010783444; Fri, 30 Aug 2024
 02:39:43 -0700 (PDT)
Date: Fri, 30 Aug 2024 02:39:43 -0700
In-Reply-To: <f388d965-84f4-44ac-b95d-26b2ecc4b1d9@kylinos.cn>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fb32120620e35e0f@google.com>
Subject: Re: [syzbot] [crypto?] KMSAN: uninit-value in lzo1x_1_do_compress (3)
From: syzbot <syzbot+02341e0daa42a15ce130@syzkaller.appspotmail.com>
To: zhaomengmeng@kylinos.cn
Cc: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, zhaomengmeng@kylinos.cn
Content-Type: text/plain; charset="UTF-8"

> #syz test

This crash does not have a reproducer. I cannot test it.

