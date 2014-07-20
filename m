From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Sun, 20 Jul 2014 08:50:06 -0700
Message-ID: <871ttg3u8h.fsf@tassilo.jf.intel.com>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
	linux-crypto@vger.kernel.org, beck@openbsd.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:1304 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbaGTPuH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Jul 2014 11:50:07 -0400
In-Reply-To: <1405588695-12014-1-git-send-email-tytso@mit.edu> (Theodore
	Ts'o's message of "Thu, 17 Jul 2014 05:18:15 -0400")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Theodore Ts'o <tytso@mit.edu> writes:
>  
>  #undef __NR_syscalls
> -#define __NR_syscalls 277
> +#define __NR_syscalls 278

You need to add the syscall to kernel/sys_ni.c too, otherwise it will be
impossible to build without random device.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
