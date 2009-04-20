From: Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH/RFC] crypto: compress - Return produced bytes in crypto_{,de}compress_{update,final}()
 (was: Re: [PATCH/RFC] crypto: compress - Add comp_request.total_out
Date: Tue, 21 Apr 2009 00:45:19 +0100
Message-ID: <49ED090F.4050503@lougher.demon.co.uk>
References: <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-4-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-6-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-7-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090307104637.GB8731@gondor.apana.org.au> <49B36A18.5030506@lougher.demon.co.uk> <alpine.LRH.2.00.0903111830540.1040@vixen.sonytel.be> <alpine.LRH.2.00.0903171345040.7595@vixen.sonytel.be> <alpine.LRH.2.00.0903241729540.4446@vixen.sonytel.be> <20090420060313.GA891@gondor.apana.org.au> <alpine.LRH.2.00.0904200925290.11211@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751827AbZDTXpk@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.0904200925290.11211@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Geert Uytterhoeven wrote:
> On Mon, 20 Apr 2009, Herbert Xu wrote:
>> On Tue, Mar 24, 2009 at 05:33:01PM +0100, Geert Uytterhoeven wrote:
>>> Here's an alternative patch, which does exactly that.
>>> Phillip, what do you think?
>>>
>>> Thanks for your comments!
>>>
>>> >From be7d630f96a85d3ce48716b8e328563ba217647b Mon Sep 17 00:00:00 2001
>>> From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
>>> Date: Tue, 24 Mar 2009 17:19:05 +0100
>>> Subject: [PATCH] crypto: compress - Return produced bytes in crypto_{,de}compress_{update,final}()
>>>
>>> If crypto_{,de}compress_{update,final}() succeed, return the actual number of
>>> bytes produced instead of zero, so their users don't have to calculate that
>>> theirselves.
>>>
>>> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
>> I certainly prefer this version over the other one? Do you want to
>> submit crypto API portion of this?
> 
> If you think I should submit it now, I can do it. But I'm still waiting for
> Phillip's comments.
> 

I think I said they looked OK to me.  But, I want to do performance tests
to see if there's any performance degradation over vanilla zlib, and see
if they cope gracefully with corrupted filesystems.

Herbert, are the other cryto API patches in linux-next (or any other
git repository)?

Thanks

Phillip
