From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: Broken userspace crypto in linux-4.1.18
Date: Thu, 18 Feb 2016 10:41:59 +0100
Message-ID: <56C591E7.5080808@suse.cz>
References: <56C47DF9.6030704@whissi.de> <20160217233353.GC31125@1wt.eu>
 <56C50725.6080408@whissi.de> <4580306.arupsYiYbb@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Willy Tarreau <w@1wt.eu>, Sasha Levin <sasha.levin@oracle.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"dvyukov@google.com" <dvyukov@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>,
	"Thomas D." <whissi@whissi.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <4580306.arupsYiYbb@positron.chronox.de>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On 02/18/2016, 09:17 AM, Stephan Mueller wrote:
> Am Donnerstag, 18. Februar 2016, 00:49:57 schrieb Thomas D.:
>> Willy Tarreau wrote:
>>>> Is there a dependency I missed in 4.1? I don't really see anything that
>>>> could have gone wrong there.
>>>
>>> Or maybe Thomas can run a bisect ?
>>
>> I cannot follow. I did a bisect between 4.1.7 and 4.1.8 as I have written
>>
>> in my first mail. The bad commit was:
> 
> That breakage was expected and forcasted by Milan Broz a couple of days ago on 
> this mailing list.

Could you be more specific? What is "this mailing list"? stable or
crypto? I cannot see anything from Milan on this mailing list aka stable.

> The referenced patch covered a bug that must have been 
> fixed but introduced a regression for backwards compatibility. Since then, 
> this regression was fixed.

By what? Please use SHAs, links, whatever.

thanks,
-- 
js
suse labs
