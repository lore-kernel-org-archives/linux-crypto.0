Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E677AEB64D9
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jul 2023 15:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbjGDPyG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Jul 2023 11:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbjGDPyE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jul 2023 11:54:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2888A10C1
        for <linux-crypto@vger.kernel.org>; Tue,  4 Jul 2023 08:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688485996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=we0f1CDdulhi3OjoFmt4741QCm67FVAPa8fyIc7peJE=;
        b=GesL3hPyoqCuTgpz0aC9Cvd5WZHsx8JpIy7mq48OEVdViux10X0W1PAb3AIy5hc3uCzk2o
        nz95tbQrIzH3Yjox+f2zvMeC51RbE7YuRMCIQbzix05gPblJYpBtmgkz1iuthutT//RRUz
        FOzHHRXBam+IwXo0SwkV95VZNMtrTE8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-I4ZJUzz0PE2EiXGsamv06Q-1; Tue, 04 Jul 2023 11:53:14 -0400
X-MC-Unique: I4ZJUzz0PE2EiXGsamv06Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA5B2185A795;
        Tue,  4 Jul 2023 15:53:13 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CA32C00049;
        Tue,  4 Jul 2023 15:53:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAAUqJDvFuvms55Td1c=XKv6epfRnnP78438nZQ-JKyuCptGBiQ@mail.gmail.com>
References: <CAAUqJDvFuvms55Td1c=XKv6epfRnnP78438nZQ-JKyuCptGBiQ@mail.gmail.com>
To:     =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Cc:     dhowells@redhat.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: Regression bisected to "crypto: af_alg: Convert af_alg_sendpage() to use MSG_SPLICE_PAGES"
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1585769.1688485992.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 04 Jul 2023 16:53:12 +0100
Message-ID: <1585770.1688485992@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Here's a smaller test program.  If it works correctly, it will print:

000: 5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a
020: 5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a
...

With the merging problem, it will print:

000: 5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a
020: 5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a
040: 6162636465666768696a6b6c6d6e6f707172737475767778797a313233343536
060: 4142434445464748494a4b4c4d4e4f505152535455565758595a313233343536
...

You can see the data from the send() ("abcd...") got appended to the page
passed by vmsplice() ("5a" x 64).

Arguably, if vmsplice() is given SPLICE_F_GIFT, AF_ALG would be within its
rights to remove the page from the caller's address space (as fuse will do
with SPLICE_F_MOVE), attach it to its scatterlist and append data to it.  =
In
such a case, however, the calling process should no longer be able to acce=
ss
the page - and in the case of libkcapi, the heap would be corrupted.

David
---
// SPDX-License-Identifier: GPL-2.0-or-later
/* AF_ALG vmsplice test
 *
 * Copyright (C) 2023 Red Hat, Inc. All Rights Reserved.
 * Written by David Howells (dhowells@redhat.com)
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <limits.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/mman.h>
#include <linux/if_alg.h>

#define OSERROR(X, Y) \
	do { if ((long)(X) =3D=3D -1) { perror(Y); exit(1); } } while (0)
#define min(x, y) ((x) < (y) ? (x) : (y))

static unsigned char buffer[4096 * 32] __attribute__((aligned(4096)));
static unsigned char iv[16];
static unsigned char key[16];

static const struct sockaddr_alg sa =3D {
	.salg_family	=3D AF_ALG,
	.salg_type	=3D "skcipher",
	.salg_name	=3D "cbc(aes)",
};

static void algif_add_set_op(struct msghdr *msg, unsigned int op)
{
	struct cmsghdr *__cmsg;

	__cmsg =3D msg->msg_control + msg->msg_controllen;
	__cmsg->cmsg_len	=3D CMSG_LEN(sizeof(unsigned int));
	__cmsg->cmsg_level	=3D SOL_ALG;
	__cmsg->cmsg_type	=3D ALG_SET_OP;
	*(unsigned int *)CMSG_DATA(__cmsg) =3D op;
	msg->msg_controllen +=3D CMSG_ALIGN(__cmsg->cmsg_len);
}

static void algif_add_set_iv(struct msghdr *msg, const void *iv, size_t iv=
len)
{
	struct af_alg_iv *ivbuf;
	struct cmsghdr *__cmsg;

	__cmsg =3D msg->msg_control + msg->msg_controllen;
	__cmsg->cmsg_len	=3D CMSG_LEN(sizeof(*ivbuf) + ivlen);
	__cmsg->cmsg_level	=3D SOL_ALG;
	__cmsg->cmsg_type	=3D ALG_SET_IV;
	ivbuf =3D (struct af_alg_iv *)CMSG_DATA(__cmsg);
	ivbuf->ivlen =3D ivlen;
	memcpy(ivbuf->iv, iv, ivlen);
	msg->msg_controllen +=3D CMSG_ALIGN(__cmsg->cmsg_len);
}

void check(const unsigned char *p)
{
	unsigned int i, j;
	int blank =3D 0;

	for (i =3D 0; i < 4096; i +=3D 32) {
		for (j =3D 0; j < 32; j++)
			if (p[i + j])
				break;
		if (j =3D=3D 32) {
			if (!blank) {
				printf("...\n");
				blank =3D 1;
			}
			continue;
		}

		printf("%03x: ", i);
		for (j =3D 0; j < 32; j++)
			printf("%02x", p[i + j]);
		printf("\n");
		blank =3D 0;
	}
}

int main(int argc, char *argv[])
{
	struct iovec iov;
	struct msghdr msg;
	unsigned char ctrl[4096];
	ssize_t ret;
	size_t total =3D 0, i, out =3D 160;
	unsigned char *buf;
	int alg, sock, pfd[2];

	alg =3D socket(AF_ALG, SOCK_SEQPACKET, 0);
	OSERROR(alg, "AF_ALG");
	OSERROR(bind(alg, (struct sockaddr *)&sa, sizeof(sa)), "bind");
	OSERROR(setsockopt(alg, SOL_ALG, ALG_SET_KEY, key, sizeof(key)),
		"ALG_SET_KEY");
	sock =3D accept(alg, NULL, 0);
	OSERROR(sock, "accept");

	memset(&msg, 0, sizeof(msg));
	msg.msg_control =3D ctrl;
	algif_add_set_op(&msg, ALG_OP_ENCRYPT);
	algif_add_set_iv(&msg, iv, sizeof(iv));

	OSERROR(sendmsg(sock, &msg, MSG_MORE), "sock/sendmsg");

	OSERROR(pipe(pfd), "pipe");

	buf =3D mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_ANON, -1, 0=
);
	OSERROR(buf, "mmap");

	memset(buf, 0x5a, 64);
	iov.iov_base =3D buf;
	iov.iov_len =3D 64;
	OSERROR(vmsplice(pfd[1], &iov, 1, SPLICE_F_MORE), "vmsplice");
	OSERROR(splice(pfd[0], NULL, sock, NULL, 64, SPLICE_F_MORE), "splice");

	OSERROR(send(sock, "abcdefghijklmnopqrstuvwxyz123456ABCDEFGHIJKLMNOPQRSTU=
VWXYZ123456",
		     64, 0), "sock/send");

	while (total > 0) {
		ret =3D read(sock, buffer, min(sizeof(buffer), total));
		OSERROR(ret, "sock/read");
		if (ret =3D=3D 0)
			break;
		total -=3D ret;

		if (out > 0) {
			ret =3D min(out, ret);
			out -=3D ret;
			for (i =3D 0; i < ret; i++)
				printf("%02x", (unsigned char)buffer[i]);
		}
		printf("...\n");
	}

	check(buf);

	OSERROR(close(sock), "sock/close");
	OSERROR(close(alg), "alg/close");
	OSERROR(close(pfd[0]), "close/p0");
	OSERROR(close(pfd[1]), "close/p1");
	return 0;
}

