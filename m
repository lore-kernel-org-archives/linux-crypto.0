From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: memset() in crypto code?
Date: Wed, 08 Oct 2014 09:18:09 +0200
Message-ID: <5434E531.10603@redhat.com>
References: <CACXcFmkQSZrQHqmcauAvpyexkjL5YpNKa-O0Or1VMuU4hawzkA@mail.gmail.com> <20141006174403.GB14468@titan.lakedaemon.net> <CACXcFmmNfgtHjwX7kJP8EKR01AMi-yujTZ55oTghJ7+J-eSzDA@mail.gmail.com> <5432E72A.3070309@redhat.com> <CACXcFmkhZSkT1_K07_bM-MREFENVvrwDrhOtQ=1XQuK-jy3WXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbaJHHSO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Oct 2014 03:18:14 -0400
In-Reply-To: <CACXcFmkhZSkT1_K07_bM-MREFENVvrwDrhOtQ=1XQuK-jy3WXQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/08/2014 04:30 AM, Sandy Harris wrote:
> I have started a thread about this on the gcc help mailing list
> https://gcc.gnu.org/ml/gcc-help/2014-10/msg00047.html

Great, perhaps you want to pass a patch proposal to gcc folks?

> We might consider replacinging memzero_explicit with memset_s() since
> that is in the C!! standard, albeit I think as optional. IBM, Apple,
> NetBSD, ... have that.
> https://mail-index.netbsd.org/tech-userlevel/2012/02/24/msg006125.html

The patch you point to for NetBSD does nothing else what memzero_explicit()
or bzero_explicit() variants already internally do, only that they're
discussing about whether to adopt it or not in their user space libc ...

Cheers,
Daniel
