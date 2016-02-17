From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: Broken userspace crypto in linux-4.1.18
Date: Wed, 17 Feb 2016 17:12:56 -0500
Message-ID: <56C4F068.8060806@oracle.com>
References: <56C47DF9.6030704@whissi.de> <56C485AA.5060303@oracle.com>
 <56C49096.6040904@whissi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "dvyukov@google.com" <dvyukov@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Thomas D." <whissi@whissi.de>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <56C49096.6040904@whissi.de>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 02/17/2016 10:24 AM, Thomas D. wrote:
> Hi,
> 
> Sasha Levin wrote:
>> > So either the upstream patch is broken, or the 4.1 backport is wrong/missing
>> > dependency/missing fix.
>> > 
>> > Any chance you could try 4.5-rc3 and see if that works for you? That'll narrow
>> > it down a lot.
> 4.5-rc3 works for me.
> 
> Linux-4.4.0 works, too.

Herbert,

Is there a dependency I missed in 4.1? I don't really see anything that
could have gone wrong there.


Thanks,
Sasha
