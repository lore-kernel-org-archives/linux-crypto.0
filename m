From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: [PATCH 2/2] digsig: make crypto builtin if digsig selected as builtin
Date: Sat, 19 Jul 2014 11:50:22 +0300
Message-ID: <CACE9dm99qMyR+141mEZ7YWsMrtpWv=MxJ9=9deofmuMbxkzTDw@mail.gmail.com>
References: <cover.1405094060.git.d.kasatkin@samsung.com>
	<7afa0a5a9343ddb354478536bd9dc670057fbebe.1405094060.git.d.kasatkin@samsung.com>
	<13187.1405627010@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	linux-security-module <linux-security-module@vger.kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48625 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbaGSIuY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jul 2014 04:50:24 -0400
In-Reply-To: <13187.1405627010@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 17, 2014 at 10:56 PM, David Howells <dhowells@redhat.com> wrote:
> Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:
>
>> When SIGNATURE=y but depends on CRYPTO=m, it selects MPILIB as module
>> producing build break. This patch makes digsig to select crypto for
>> correcting dependency.
>
> I'll apply this one.
>
> David


Thanks,

Dmitry
