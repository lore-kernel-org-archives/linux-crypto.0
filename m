From: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 08/62] x86: remove the second argument of k[un]map_atomic()
Date: Mon, 28 Nov 2011 14:35:03 +0200
Message-ID: <4ED37FF7.2060207@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com> <1322371662-26166-9-git-send-email-amwang@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Olaf Hering <olaf@aepfle.de>, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org
To: Cong Wang <amwang@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421Ab1K1MfZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Nov 2011 07:35:25 -0500
In-Reply-To: <1322371662-26166-9-git-send-email-amwang@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/27/2011 07:26 AM, Cong Wang wrote:
> Signed-off-by: Cong Wang <amwang@redhat.com>
> ---

>  arch/x86/kvm/lapic.c               |    8 ++++----
>  arch/x86/kvm/paging_tmpl.h         |    4 ++--
>  arch/x86/kvm/x86.c                 |    8 ++++----
>

The kvm parts are:

Acked-by: Avi Kivity <avi@redhat.com>

-- 
error compiling committee.c: too many arguments to function
