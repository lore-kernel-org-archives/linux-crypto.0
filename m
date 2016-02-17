From: "Thomas D." <whissi@whissi.de>
Subject: Re: Broken userspace crypto in linux-4.1.18
Date: Wed, 17 Feb 2016 16:24:06 +0100
Message-ID: <56C49096.6040904@whissi.de>
References: <56C47DF9.6030704@whissi.de> <56C485AA.5060303@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "dvyukov@google.com" <dvyukov@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <56C485AA.5060303@oracle.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

Sasha Levin wrote:
> So either the upstream patch is broken, or the 4.1 backport is wrong/missing
> dependency/missing fix.
> 
> Any chance you could try 4.5-rc3 and see if that works for you? That'll narrow
> it down a lot.

4.5-rc3 works for me.

Linux-4.4.0 works, too.


-Thomas
