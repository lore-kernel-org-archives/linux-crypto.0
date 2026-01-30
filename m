Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F80D37F113
	for <linux-crypto@vger.kernel.org>; Fri, 30 Jan 2026 12:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769777963; cv=pass; b=NqiF5OQwNVWTKPKuJbdO85PbpufzZD8qIx8lrw6mAWEn7ccnO0B+bk3AXNkkLi9zUKRGAFwxLe0oD9G1PyKMFeJ0oMZCpF8PEpKSxg3Fz5fvc9phZmN8a0KCUhgeeKgKspLwr9KdSY0BzjU0t3e/QAVoe7wyNTuGQAwPjI/MS7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769777963; c=relaxed/simple;
	bh=xG0HoGtWgtaeO6rMJ6ftZ42hhmA+SOj2D6UatodVRxE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=EQl5JkIoxmGpbcfGbbNbpZVbkmOA9HvoEVDFmw4Y9tdgCaafRgQ7P10m24uqOd1TNWPAmyrkJ4dKfj0f91dc/8j8x+nBmiHL2eoUjjU8PaCZaRl5Lc8ULErNa8IaNEB4ukUCpsE5RHSrTDt/Nn28LIG5SEORlhTe7HvRu85wFhU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lYWwVwOl; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lYWwVwOl"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-65819e75691so3613256a12.3
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jan 2026 04:59:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769777960; cv=none;
        d=google.com; s=arc-20240605;
        b=fi+JgdDRLZdkich72j74JX06lyghcOvFHNA8xnY/r5YPbGMQzO6J5muNqBZMcHBEOg
         KHelsifRXlg5bK5FOYAJDMzlK+W7jKrU2et0xJS7V/xBzWhuI5d6bDSQ56JT+IqjS5Lr
         0KsTcugSYabT9dddOw22gb60vxt2AJzQ/sbdnOqLJIFlYqvBCedonrmeu0DTi1u4M2uY
         lSp5kFv50NZdpC/faSTSMEgAMI5wDbvKKqHWMWVeoLuMKLbQ5oa1n+kc7tW6WfYYZvdC
         WYfjv/S00Kc7oq8Pmiqh0rPuLoTOcBloJaINL/VpyEfoLSna7MZBQorqy3bf0T/nt1fz
         JqpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=/5hVLHdfoH2KEaRhGo53o2eC57XReA1/Lk8YzkL01/8=;
        fh=lFoZMv6n4xFsjsZhIP9su14HJja5A+wqcdw18a2I3UI=;
        b=YDPg8F50XPvaN1Pet4n/zJzJTahFGs6xC57SmuKo3STm/BxV/ZGW/3Cuqr7Yo6cZdW
         LYkv6uVNA2K7kdAvF05EiknY+ShAGghBsmsSVV8o0cj8v2dFo6uUDcRJrIF5PGrQ4k3t
         G/ru8ycxXOoi1hAAwyxvkSKcQdqa2rWZA5IXvRbX734i9qH93zz5mMosrvz0RtsBcLXz
         0V0bmznmr9PKqmyVIp0+E96vovPpcEQCCvPxhVUtza69tiPbwognxSnK0T68fN9VOaIR
         Bv7FhJ7G9Pnge8FRRoGGyGNUOG/L0GOrIcBHufrU3CD/Ac3oUGymp8nx/fSKtLURRECY
         eisw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769777960; x=1770382760; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/5hVLHdfoH2KEaRhGo53o2eC57XReA1/Lk8YzkL01/8=;
        b=lYWwVwOlgaPWDuDiRwKlFgDXMzdOrGvIXHLY8DKNG1lenuvrI5RvK4G8Qw/jlkBjCW
         TuWUcRkZnTBpUv6AgjdMngTt+a+7mLecXSFWkg6w/ZBldxl5T6FxafK+tYJ64IiW1x9x
         zQwTvmL42+yNz9VkV03ndd5W8ER1d8x644mZfRWDrKU3WzDxkVwWVA9/QHiyENZDIh7Z
         DQszxYhE0zB6XXH+jqYCvT+8cKE063yS+0nep5Wn/bvYXBxuwPtGa69zQ7wYTZ1/fb8g
         Phh6r2HZGMR4/JL/pk16RkMCJ3dFw91M+gHWP6Pe7fWLPa/Es7KGLGg+83Izlope8zSk
         39Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769777960; x=1770382760;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/5hVLHdfoH2KEaRhGo53o2eC57XReA1/Lk8YzkL01/8=;
        b=nGNKnKi0H57ObIgLELN56zJYo+DlmH9pjWwLV2qQ0zmLHu2LX7mGpbR/OAi3vt3xKU
         gEh+RbmIviwebHSXbBS3s/M+ddWMAi74aJW40yE7S8MFpxg///hnaDNaAdk3veCzuOmb
         5HVpKaOy1xUJwmJn+TsTG1OqlC+fn/opsvZ539myhgIyoMsBTShXUTf1J7XSMEFCtX1X
         GHdEj1LWpF9R3mtxsPoiRu2McRgbuhXJiL0861fe0pImkyHBrBMClaebgPB4VcLsBb+0
         KbiTYft8/SdzGY549HHJBbiu3IFanguVqY9RyDYXewdgxWExEbmigWS4+2zJcFeTuudV
         KJlA==
X-Forwarded-Encrypted: i=1; AJvYcCUK7HqfhUW0WCU08uEgUmskPa36eGoNkgHkrX98Ux0cHNV+w9bmecotWh/Cxcc4S5z9rgTqDIwAqdjGkCQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPuzLAvxNtGo4S70XHj8KNCEMW88FYUzC21EiCfDbIO0lvz4cp
	sRUvnHouI/61Ny5A36yWwdkjm6yG4eMQyqPij4MJy9xLFiBlGyllhxP/Skwh62l7fpyYAK/iuxr
	NzChdWqbVJnXJ5HPnJ7rKMWMIZ7nWgQo=
X-Gm-Gg: AZuq6aLqSTXL8gAPoswmktffbQVEaN5vqfKujezzTlE6N297qAXK/aBdF9dECvKNwLC
	mOY7oli99W2WSq5XtcCaTYatG4+9EXWENKBGdE6+yzZ74fY1KDc7DXckvDVKyb/aKy1ge+Mc/zB
	sVZNyDLJ5Scq+DEzkS5eqcdgoG4fyG+BTMCiw6nGy+VeFlyOe8QWDc1wPAVqCd+/4GQw+7PFJZ1
	oX8NHWtEesh7bi4omWIuYbvjC5Ga0LvbUJMpvFF9nEbZBcK4DV7LYTJo6Ogjt8tCuwc6Q==
X-Received: by 2002:a17:907:9303:b0:b87:1b2b:32fc with SMTP id
 a640c23a62f3a-b8dff221092mr159144566b.0.1769777959652; Fri, 30 Jan 2026
 04:59:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1769026777.git.bcodding@hammerspace.com> <0aaa9ca4fd3edc7e0d25433ad472cb873560bf7d.1769026777.git.bcodding@hammerspace.com>
In-Reply-To: <0aaa9ca4fd3edc7e0d25433ad472cb873560bf7d.1769026777.git.bcodding@hammerspace.com>
From: Lionel Cons <lionelcons1972@gmail.com>
Date: Fri, 30 Jan 2026 13:58:42 +0100
X-Gm-Features: AZwV_Qg9cHb_cy5s1iZbkKmSD6O6rh8Vs18I0Fb-ECMjeghOuBS5bTI7gCCvHXs
Message-ID: <CAPJSo4XhEOGncxBRZcOL6KmyBRY+pERiCLUkWzN7Zw+8oUmXGg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] NFSD: Sign filehandles
To: linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 21 Jan 2026 at 22:03, Benjamin Coddington
<bcodding@hammerspace.com> wrote:
>
> NFS clients may bypass restrictive directory permissions by using
> open_by_handle() (or other available OS system call) to guess the
> filehandles for files below that directory.
>
> In order to harden knfsd servers against this attack, create a method to
> sign and verify filehandles using siphash as a MAC (Message Authentication
> Code).  Filehandles that have been signed cannot be tampered with, nor can
> clients reasonably guess correct filehandles and hashes that may exist in
> parts of the filesystem they cannot access due to directory permissions.
>
> Append the 8 byte siphash to encoded filehandles for exports that have set
> the "sign_fh" export option.  The filehandle's fh_auth_type is set to
> FH_AT_MAC(1) to indicate the filehandle is signed.  Filehandles received from
> clients are verified by comparing the appended hash to the expected hash.
> If the MAC does not match the server responds with NFS error _BADHANDLE.
> If unsigned filehandles are received for an export with "sign_fh" they are
> rejected with NFS error _BADHANDLE.

Random questions:
1. CPU load: Linux NFSv4 servers consume LOTS of CPU time, which has
become a HUGE problem for hosting them on embedded hardware (so no
realistic NFSv4 server performance on an i.mx6 or RISC/V machine). And
this has become much worse in the last two years. Did anyone measure
the impact of this patch series?
2. Do NFS clients require any changes for this?

Lionel
