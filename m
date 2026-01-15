Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FC431DD90
	for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 19:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768505893; cv=none; b=aVbIdAgfzWWEZ/1ucgOoH49SRMNiCSQrRGgCDxnQbE8GqRXUwK+dUWlo3Q16Li49bHUEx7QcpgDviDh9lXvRXoLetmokuCw3p2Wvz/jWtxP0hpDXGlCxVy3hG1DVTK2TjbPvbX6LzooWlvVR43NFGqCbfzV3eRu3VjA4Wa3ODcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768505893; c=relaxed/simple;
	bh=BVuRcIp9C9aDs7YujmRCIsJWyiCOSqmqC7FZNs5wMUU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=WdsiUp2+fEBgSAD+C+w6XJgBfDcahT4mIJOw198DU9sUrsPBMLzlHP8YFVnm6GG6Vx6AXpXtqL+bWIa78dQubSL+/mgd2u/AitLqc9bTFWvy48jTrBlJGQoffc5ib9JRn0mZkskYieWuAnDu9qHXlCBaYvUkIguExVwRHe3I9Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oasis-open.org; spf=pass smtp.mailfrom=oasis-open.org; dkim=pass (2048-bit key) header.d=oasis-open-org.20230601.gappssmtp.com header.i=@oasis-open-org.20230601.gappssmtp.com header.b=PXlvlbgq; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oasis-open.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oasis-open.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oasis-open-org.20230601.gappssmtp.com header.i=@oasis-open-org.20230601.gappssmtp.com header.b="PXlvlbgq"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8c52f15c5b3so148024285a.3
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 11:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oasis-open-org.20230601.gappssmtp.com; s=20230601; t=1768505889; x=1769110689; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BVuRcIp9C9aDs7YujmRCIsJWyiCOSqmqC7FZNs5wMUU=;
        b=PXlvlbgqfCOufxgSurRGnxzAEa2ccoxiMo3RihbPuehvg9kNFOIYjBenFkMbNBUJPu
         CUWmpTr+ApQjUDBWzXATKq/mLZIeD6Oq/b2SKlK2L/TuNwpmwfBhKXDoDN1BHMUZXJEj
         tW0DbChW4NCTW4r0e7PRtkREhx17eO4Gbc4DlcMigLvsGgDdkevCeQx5XIUBHdXCbICi
         Y7j+1JuN3uGDpug1Wnpf1qyHnID+jgElnOa06bsVs4beAV22FtFQl9fgOXXsmlEIiiM+
         cXD1VJpX32NCGyL42IBQzlOH49En+WoAJlewf4P0yZZ+ORB4i8sSXKbGOtySky6Ylgte
         geDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768505889; x=1769110689;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BVuRcIp9C9aDs7YujmRCIsJWyiCOSqmqC7FZNs5wMUU=;
        b=DbPobHEhWplCrcSOWlf9kFJ9lba3KPqb4av2Wn8fvi5Gt6QgHnoX7YCkbc4x71QVRB
         YMQyPXygKq7j8F/C7byeQkNfwIp7Jw3jdFc9ZWIzN7ENo+5q4DrfYkApfJQjAQHcF8nK
         Bpmmi2u/12iZS3DsgsO36CUKx9enkBcWizCKlBhniurXE9eBeIhnsW1QRpt9a6rtOl48
         WYXusIVTibuLVu2lRCRVwTYx4A/EXajvg30SD+FtfHHgSD0UC4WJdTvyQd4ny6Q3nf8c
         R4Uo9Xs5Mqi0qHki3fZOJcI9AnYHC1+xU/LaAEQ/afc3ZZPX3lTUH0N57a8Ns21Vw6ii
         R+GA==
X-Gm-Message-State: AOJu0YzKTazI7couo6vRW1e4dJXk9Czl36N2pvZPB3i/rnV8bsx5hT7S
	Yaq19R2HPunI99aiGwpAC83DbBe36v+uXifOvoh/JrXbYHys/IDxojNX9bTs/13EPZUxDbNunAY
	si/KB64PVXNUbSXJruFYuUXKfW9R6u1rYkFjjSJz4UvYazzSF+NT9LhY=
X-Gm-Gg: AY/fxX649gIij2E9Kqq4xhpuSKglqVd2zVTMGxkv88BCHQH11JgWVKzwvRpm8d93jC8
	eFDD7FkZQ2L5dk3OCskTTsJ1ol2dQhhVxMHKIzPOKIvSMgpADR93AE67Yj5mbYlNk7ypi+5MYd0
	V5qwh3r8cADGV7OYl1iZ7URQKiH/hWo71+9b7/oMYNC8Oru13428ypDfIdtdgyJlo+OTo+63JQz
	aiH2ctSEBT+4Bi1DviJofoK4pAkJbvmSyu+4eLcdyYjN1qkDhnBC0BkgqmHistE1FcCh4+fNWWT
	559SJjKKMxdB0xMiOSIbwcFEpQLS0kybtuJP9i8LkkXChZ3MN9ZSaBLnF1Po
X-Received: by 2002:a05:620a:404d:b0:8c3:5a72:b11 with SMTP id
 af79cd13be357-8c6a67bcc30mr85115985a.90.1768505888823; Thu, 15 Jan 2026
 11:38:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Kelly Cullinane <kelly.cullinane@oasis-open.org>
Date: Thu, 15 Jan 2026 14:37:32 -0500
X-Gm-Features: AZwV_Qic9dD4j9vN7R_KFHig6C1S8I6obC-f0vZZqNReml1uaDRdNKKI0-SqU20
Message-ID: <CAAiF60010CRW7i3-s2xNzXiXO298MCcxTHot=ZosAyM6P4b8BQ@mail.gmail.com>
Subject: Invitation to comment on VIRTIO v1.4 CSD01
To: linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

OASIS members and other interested parties,

OASIS and the VIRTIO TC are pleased to announce that VIRTIO v1.4 CSD01
is now available for public review and comment.

VIRTIO TC aims to enhance the performance of virtual devices by
standardizing key features of the VIRTIO (Virtual I/O) Device
Specification.

Virtual I/O Device (VIRTIO) Version 1.4
Committee Specification Draft 01 / Public Review Draft 01
09 December 2025

TEX: https://docs.oasis-open.org/virtio/virtio/v1.4/csprd01/virtio-v1.4-csp=
rd01.html
(Authoritative)
HTML: https://docs.oasis-open.org/virtio/virtio/v1.4/csprd01/virtio-v1.4-cs=
prd01.html
PDF: https://docs.oasis-open.org/virtio/virtio/v1.4/csprd01/virtio-v1.4-csp=
rd01.pdf

The ZIP containing the complete files of this release is found in the direc=
tory:
https://docs.oasis-open.org/virtio/virtio/v1.4/csprd01/virtio-v1.4-csprd01.=
zip

How to Provide Feedback
OASIS and the VIRTIO TC value your feedback. We solicit input from
developers, users and others, whether OASIS members or not, for the
sake of improving the interoperability and quality of its technical
work.

The public review is now open and ends Friday, February 13 2026 at 23:59 UT=
C.

Comments may be submitted to the project=E2=80=99s comment mailing list at
virtio-comment@lists.linux.dev. You can subscribe to the list by
sending an email to
virtio-comment+subscribe@lists.linux.dev.

All comments submitted to OASIS are subject to the OASIS Feedback
License, which ensures that the feedback you provide carries the same
obligations at least as the obligations of the TC members. In
connection with this public review, we call your attention to the
OASIS IPR Policy applicable especially to the work of this technical
committee. All members of the TC should be familiar with this
document, which may create obligations regarding the disclosure and
availability of a member's patent, copyright, trademark and license
rights that read on an approved OASIS specification.

OASIS invites any persons who know of any such claims to disclose
these if they may be essential to the implementation of the above
specification, so that notice of them may be posted to the notice page
for this TC's work.

Additional information about the specification and the VIRTIO TC can
be found at the TC=E2=80=99s public homepage.
