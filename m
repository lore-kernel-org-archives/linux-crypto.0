Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45F42E92A6
	for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 13:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755093120; cv=none; b=hipvQXkUGGvyXoFNWt4/GxPJ3W/opMKQAJ4E0gEzwbwrLqPHR0b1uhjlz0jc2v+YSe8/1iV5RvgsHCtRmXSUGPohWINGpI/i75ctxcOMQWiw27wT+4JBsDvN68VZslnRo6BLqaxPURkxzlvUdmzV8A8a2GGV4IsG5XqgMyl0Tb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755093120; c=relaxed/simple;
	bh=/YIVUF9I/djWNkR5dVY1IXqe1OIT1s+0c1FcuOgW4MI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s81hnXej5tLZt7cTtzCWsJewmd6UQbTXQObVccmtLGr9MUhgPV/MvbTVw+57HQzFpefokpjprIJ3edyLVqZ7rdpMcG4fAf+QQoFgfD8DV3eQnWTj3cQBsvq7bf5TCISvOlNpNoctrz0CVPiZWCfeP2PmNNuaMriCQKKIGo1DDbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AhcVXZKg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AhcVXZKg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755093117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=khCHV/jiyg83R0WJ+N6KJ8Z0/D4dsCSn9la+i31zeWA=;
	b=AhcVXZKgn7X+Y/eN9/bfOcR0VBwGeo33d92z7DfiI00AYAw2SMx3HGNjgU+7nfV9QqsaCX
	QAmn2Q54wO9KBjVwnGL8G8b2Xu5o/z05rquzzAKXDybvDImhsNJ5GrPxs/LKMSWuXE8ds4
	S2PI24DXfFzt896mLTUp9Jvd2/0ihWA=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-PlK10m0cOQCo5MBktOjeBQ-1; Wed, 13 Aug 2025 09:51:56 -0400
X-MC-Unique: PlK10m0cOQCo5MBktOjeBQ-1
X-Mimecast-MFC-AGG-ID: PlK10m0cOQCo5MBktOjeBQ_1755093116
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-8841c18a4bfso442615439f.1
        for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 06:51:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755093115; x=1755697915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=khCHV/jiyg83R0WJ+N6KJ8Z0/D4dsCSn9la+i31zeWA=;
        b=nHietFW2HQl5mgMUWKYzgE7OgmjbrORi2L0YA24NKmaO2WIIiMiVR4/B1XCeNiGoAd
         qr3W1+5o0QPbTIdoVdKQ/x37wO96agrAOjDrksQsPMVpDaGg8Cou+zQi6jrmVKqQ2WDh
         ati+BuAMV6aAQvZkqRoq+XVO/1RpqDQ0ByndHV31YRmmmIEbKCKXdXDKIEf7x2WniWE3
         zvYnTiklfUvZLTaJbyclpHpJG4YbtrzihMMt9hDSAGS63VEIkODja/sUc2ifJrT+zeaG
         RhwbxINbQi91dJNW5tj8JW4P2hzN5PII8eXpEUL/5IbNzHoNSpOPuGDbXay1+EVV8u2G
         C7jQ==
X-Forwarded-Encrypted: i=1; AJvYcCV50ofRmx+jLEdEBxiSB4UuwugpMCSlQUnyK7hOhTnFByM7mtkcna1G2kHR8oFSjTZhWvrhIOH8nHMWaZE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAoIRTDO+V9NBrNX1YtGQqumQgqI2ZbGJ97QG48OEVof6ODQfB
	EGVuV12+81I0DOHfGkWh7CMnMiRF8DK62RaZCfsuQHifwu4tywFFJ0RpZEopMFSUUGvR8vFiPju
	kCo0FXhhOqqbDc0tEmGwdo1YDAexJqpKGXKeKThdjd1vDBl7Pe2i0K7z2D/yt4vlmXqHBdnUouW
	ZDxzr1XJsu/QaMGFgwNkZi44g701KGDa23WlSVaA6b
X-Gm-Gg: ASbGncv/J74diFzy6OQFi+j2buCQlU4Y9aUhc4mUwxILgoCL1MOcYDQTTBAA7rAiy87
	tukh6s0QwAu/qix31FVE4vJ7w6PyrSh58sTkTZEaI6OdYyEQahcUbImX/9PjgSCbCBXDA2s+stL
	XdeZKQnrHM/8++Jo7s82I=
X-Received: by 2002:a05:6e02:228d:b0:3e5:4ca1:b4ba with SMTP id e9e14a558f8ab-3e5674ad5a0mr57228965ab.21.1755093115559;
        Wed, 13 Aug 2025 06:51:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJrB7BO+c1UaLLpV9GR/FNkILk2BEusWu+kwIhF584pu5dil43i2ipOVq0f8jkTMjrGx8KI3/Knz6ZAQj7Wd8=
X-Received: by 2002:a05:6e02:228d:b0:3e5:4ca1:b4ba with SMTP id
 e9e14a558f8ab-3e5674ad5a0mr57228025ab.21.1755093114707; Wed, 13 Aug 2025
 06:51:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <87plczcttb.fsf@li-0ccc18cc-2c67-11b2-a85c-a193851e4c5d.ibm.com> <87v7mrfle9.fsf@li-0ccc18cc-2c67-11b2-a85c-a193851e4c5d.ibm.com>
In-Reply-To: <87v7mrfle9.fsf@li-0ccc18cc-2c67-11b2-a85c-a193851e4c5d.ibm.com>
From: Justin Forbes <jforbes@redhat.com>
Date: Wed, 13 Aug 2025 07:51:42 -0600
X-Gm-Features: Ac12FXzuoyxYfMxS9ejmMuo4Uk-MEGqs0gHdexKO70_Nors6enJlkRNg0iBTCP4
Message-ID: <CAFbkSA3_5MY+J1gqLzq7kEn9KJKF3E6-614igBqmHVoS=UVPWA@mail.gmail.com>
Subject: Re: [bug] pkcs1(rsa-generic,sha256) sign test and RSA selftest
 failures, possibly related to sig_alg backend changes
To: Alexander Egorenkov <egorenar@linux.ibm.com>
Cc: jstancek@redhat.com, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, lukas@wunner.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2025 at 6:37=E2=80=AFAM Alexander Egorenkov
<egorenar@linux.ibm.com> wrote:
>
>
> Okay, i identified the code which is at fault, and it is indeed
> Fedora's kernel fault. And it explains why PKCS1's sign callback returns =
-ENOSYS.
>
> https://src.fedoraproject.org/rpms/kernel/blob/f42/f/patch-6.15-redhat.pa=
tch#_510
>
> But why was this change made ?
> All signing callbacks seem to be overrided with sig_prepare_alg() for som=
e reason.
> We would like to use PKCS1 signing algorithm provided by kernel.

Thanks for the catch, and sorry for the noise there. We do carry that
patch in rawhide, along with several other that change Crypto for RHEL
FIPS which upstream isn't interested in.  I typically drop those (and
many other RHEL specific patches) when I rebase stable Fedora.  But
those are poorly labelled and I suppose I missed it with the 6.15
rebase.  In normal rawhide, that is part of a larger patch series and
makes more sense.
Anyway, the patch should be dropped from the next stable Fedora releases.

Justin

> Regards
> Alex
>

