From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: memset() in crypto code?
Date: Tue, 7 Oct 2014 22:30:13 -0400
Message-ID: <CACXcFmkhZSkT1_K07_bM-MREFENVvrwDrhOtQ=1XQuK-jy3WXQ@mail.gmail.com>
References: <CACXcFmkQSZrQHqmcauAvpyexkjL5YpNKa-O0Or1VMuU4hawzkA@mail.gmail.com>
	<20141006174403.GB14468@titan.lakedaemon.net>
	<CACXcFmmNfgtHjwX7kJP8EKR01AMi-yujTZ55oTghJ7+J-eSzDA@mail.gmail.com>
	<5432E72A.3070309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:50439 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaJHCaO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Oct 2014 22:30:14 -0400
Received: by mail-ig0-f180.google.com with SMTP id uq10so6724265igb.13
        for <linux-crypto@vger.kernel.org>; Tue, 07 Oct 2014 19:30:14 -0700 (PDT)
In-Reply-To: <5432E72A.3070309@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I have started a thread about this on the gcc help mailing list
https://gcc.gnu.org/ml/gcc-help/2014-10/msg00047.html

We might consider replacinging memzero_explicit with memset_s() since
that is in the C!! standard, albeit I think as optional. IBM, Apple,
NetBSD, ... have that.
https://mail-index.netbsd.org/tech-userlevel/2012/02/24/msg006125.html
