Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7621730C178
	for <linux-crypto@vger.kernel.org>; Tue,  2 Jun 2026 08:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780388396; cv=none; b=GZbjYX789RnWB7of93g6g+krjCm4nuOZXXpnz9kPvFIbOSz7Xgljy7JXvp3y2itLGACr00NaPBFfhNge9whEIIy6jFYZZgoUzUxkBN0IzgJIL9hTpJ6K0aeQ8Z/AodHtpBN0mdH2tbPK0ZhvpHzPp7v2fxxVu2ZGqtzgCb1ADD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780388396; c=relaxed/simple;
	bh=9499/dtEzvbd3zJGfbp9kvlKjetgCUOQX++M2hibPBs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HsSlblJox9y4X4xXaMCoVRGA8qEoG7+n2VY2SBUbcwSVwDWizimDgIGR0GYA71jl8D20pThbrhTrCR2VTYP/5ZPeOZOxZ+rRCxE7gn5aIABL6whCTsTrT6CsTi6Jc1idDss70mQ70lVEVOH7FmdgK/yyf939OoHsHuQmP3UYa0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E/bVHOFO; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E/bVHOFO"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bd9a71b565aso2272726066b.0
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jun 2026 01:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780388394; x=1780993194; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1J58zYVOxjT05eGzIhiq9/KJruLuJi2wXiKnFBUSeD8=;
        b=E/bVHOFO3W+DoR/7h9EUnDOqzKifon9i7hNo/bFphCrprwMJBL6ciABUceBQOOf8MI
         h8vXewsqetl0aRjYWJSuJ4YA5Lff8gxim9CgCl+C0bbhd2H7imfhVqE0/1mkiZMTLgrx
         d1IZGWNhWWXQqzZ/gisxo/jObswr2A5evrfw002l8xOCNYQILZG6AOZuAsIQlxI7BDJp
         ADBYgdkdcNXVjof9lK8dobUKZFKu3vYwCP3sOcpR0QNiTCTBNJxLxqUIkHi2b/LgOPAv
         vCWww4QLKfICrx4S0GTHi7sw89I/Bgx9O01V2Ap2z8RJAuwsbnMYSjov3ilJrA00w0n5
         qRsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780388394; x=1780993194;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1J58zYVOxjT05eGzIhiq9/KJruLuJi2wXiKnFBUSeD8=;
        b=C+Tzrt6JsvkGSUsIzbtVi5fKc9gvEG+7NDZxitYj+y6IJQZkQirNlkjHv8uYBkrNTe
         dKz/lTnGaQva8G4bbPFupvyl0MMTMp/3Xf7+4WQHLR7EI3vqta57nK3olJGbTz0O9It6
         gZfkeJ2xLMsMYykqkUXIHID0vZcJZsPhAvfKMgrffBJS998q7kjOWZSUtKn7CcdYZVgB
         I3egqpHrte5uXPHz3S5AKZ9OqDtp+9J+YEslHa7/laJ2W4buG9befEJhXQS/MuJBlC4m
         +FUqVYFLww4hdcZ3BJcFHl7BK6ogs32ri96Q82wuIjzyv3FNKXO0yr7sf/vxAcl7SaU5
         pXYg==
X-Gm-Message-State: AOJu0Yx60IkUnxVCzLiPrR1ClxyrTtFUl5OKc2IRJQGknzvqL+wZinlt
	wQvxuvFGS22JkHiz4rzOpIN1CZtIdtHZ93clBqETYh8yX1Pj7M84n43j
X-Gm-Gg: Acq92OFo7bZbQ79rHrenPHu+3jHRt6JVF8gLCYk00F4uxpqJuLpgcgYIBHuIfXuWsE2
	IE4iALIvux0iXEGCVnIdnmb+lRocOHiaHiheF8Egq/NjCuzpY2O9666xt7wPZ5Npp4WJ/9hdIto
	vqtRSaqzAiAf8KesV97RJuHKzj0sFMpD2eLwBCGcYAGArz1sdkTGrdZm3XqftflTkl3+tAxlLdn
	FuLHWel483SJnScFSLhbMC672CqbQt2OO53RJBBkyKGVFQUQottPQQjQKr7y7nAb8xmoDh1ks4I
	6eRAoM9PKt83eKk3Vzn5z2H0jixLh+jGdTB4zQSRboyYrz9PjT5OHZ9ZnLHXGHoAJhgJ5zu6fJQ
	xzWNopBU2oUIU41EqRehpuqRhsLm9AlcMT4TVIFF9E/5k3SnNfCbULVgtFovW5tHRGniRiYUDaS
	YUfvPP7TyiMStubx3Ma3rO1C+mPEjQCrVqWuQM/aB9
X-Received: by 2002:a17:906:fd87:b0:bd1:ba38:c724 with SMTP id a640c23a62f3a-beab5af6080mr848686066b.32.1780388393782;
        Tue, 02 Jun 2026 01:19:53 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bed10b15eb7sm235633466b.35.2026.06.02.01.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 01:19:53 -0700 (PDT)
Date: Tue, 2 Jun 2026 11:19:50 +0300
From: Dan Carpenter <error27@gmail.com>
To: Eric Biggers <ebiggers@google.com>
Cc: linux-crypto@vger.kernel.org
Subject: [bug report] crypto: omap - switch from scatter_walk to plain offset
Message-ID: <ah6SJiFErFV17cMi@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Eric Biggers,

Commit 42c5675c2f5b ("crypto: omap - switch from scatter_walk to
plain offset") from Jan 5, 2025 (linux-next), leads to the following
Smatch static checker warning:

drivers/crypto/omap-des.c:842 omap_des_irq() error: we previously assumed 'dd->in_sg' could be null (see line 844)
drivers/crypto/omap-des.c:872 omap_des_irq() error: we previously assumed 'dd->out_sg' could be null (see line 874)

drivers/crypto/omap-des.c
    823 static irqreturn_t omap_des_irq(int irq, void *dev_id)
    824 {
    825         struct omap_des_dev *dd = dev_id;
    826         u32 status, i;
    827         u32 *src, *dst;
    828 
    829         status = omap_des_read(dd, DES_REG_IRQ_STATUS(dd));
    830         if (status & DES_REG_IRQ_DATA_IN) {
    831                 omap_des_write(dd, DES_REG_IRQ_ENABLE(dd), 0x0);
    832 
    833                 BUG_ON(!dd->in_sg);
    834 
    835                 BUG_ON(dd->in_sg_offset > dd->in_sg->length);
    836 
    837                 src = sg_virt(dd->in_sg) + dd->in_sg_offset;
    838 
    839                 for (i = 0; i < DES_BLOCK_WORDS; i++) {
    840                         omap_des_write(dd, DES_REG_DATA_N(dd, i), *src);
    841                         dd->in_sg_offset += 4;
--> 842                         if (dd->in_sg_offset == dd->in_sg->length) {
                                                        ^^^^^^^^^
Dereference.

    843                                 dd->in_sg = sg_next(dd->in_sg);

Imagine that sg_next() returns NULL, then the next iteration through the
loop will crash.

    844                                 if (dd->in_sg) {
    845                                         dd->in_sg_offset = 0;
    846                                         src = sg_virt(dd->in_sg);
    847                                 }
    848                         } else {
    849                                 src++;
    850                         }
    851                 }
    852 
    853                 /* Clear IRQ status */

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter
