From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 00/19] RFC, v2: "New" /dev/crypto user-space interface
Date: Wed, 25 Aug 2010 11:28:44 -0400 (EDT)
Message-ID: <1626059641.38051282750124404.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <20100825062000.GA1424@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-crypto@vger.kernel.org,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:34363 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751397Ab0HYP2v (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Aug 2010 11:28:51 -0400
In-Reply-To: <20100825062000.GA1424@ucw.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

----- "Pavel Machek" <pavel@ucw.cz> wrote:
> > * Advanced crypto module for OSPP for Common Criteria requires OS services
> >   implementing several low-level crypto algorithms (e.g. AES, RSA).  This
> >   requires the separation of crypto services from the consumer of those
> >   services. (The threat model is that apps tend to have more vulnerabilities
> >   than libraries and compromise of the app will lead to the ability to access
> >   key material.) An user-space library is not separated, options are a) root
> >   running daemon that does crypto, but this would be slow due to context
> >   switches, scheduler mismatching and all the IPC overhead and b) use crypto
> >   that is in the kernel.
> 
> Hmm, root daemon seems like a way to go. You already do the switch
> into the kernel... and "IPC is slow" is not good enough reason to put
> everything in kernel. Plus, you should be able to get better usage of
> multicore with daemon.
> 
> Numbers?
Posted here before - adding a single syscall (to the one existing ioctl()) adds a 20% performance penalty when encrypting 256 bytes using cbc(aes).  Even with a 32KB block the penalty is 2.7%, and lots of crypto is done on quite small data sizes.

Inter-process IPC would have even higher overhead.

Using more cores is actually easier with the kernel implementation, where each crypto operation runs in the context of the calling task.  This naturally scales to the number of concurrent tasks; as Tomas has said, none of the existing crypto APIs naturally support parallel operations started by a single thread, so any performance advantage gained through this is unrealistic.  A daemon would have to explicitly create a thread for each core (and watch for CPU hotplug?), and the incoming requests would have to be distributed among the threads (with system-wide lock contention on the request queue/pipe/socket/whatever).
    Mirek
