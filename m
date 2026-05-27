Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411D334A78F;
	Wed, 27 May 2026 21:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779917922; cv=none; b=U4jYTycUsrMtfnyVxguvm7l7RTZNuEw60McdLo4jmpnq9a09avB7O0m81yAOMc+T1upAXLvHnbvkuJmRuuMa6dRrJoJUvRTHLP0WfnJkwnxg2Ycx5/diWahrbQZFZIh6ImgDu1dqElb03lopRjLbE9vk1b0KHUBLxByiMZjbFeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779917922; c=relaxed/simple;
	bh=FPyNy2YSF8CjJXQfyuprUDSuQrunC+miirGOZ22atdA=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=RQhSZYiRLIUhF90I8bUNlS6k6YbJNfxSJTopn7Fp93TFcQroRV70myhj5a3lb6rXpuEtvzRl6DJbaLkrgT/DLj7ZIXnizPi5kV4T9Mi3qIYVE9cEQh6y1KuTmmEYzKReU+cYxT2V5h8l9i/fZxUS1dZoxT/rv7TZfzAYuwRRV10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RLIfRoL6; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RLIfRoL6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779917921; x=1811453921;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=FPyNy2YSF8CjJXQfyuprUDSuQrunC+miirGOZ22atdA=;
  b=RLIfRoL6rPg9f7YRRUjEtn2vvj3rctpZagRp3RMoViRb4EK1Qfhkn0F7
   MGXuFgN3XA5B97Y+55G/rQMkyrMiIt3tUEB4V5Rdane9ulPuYOD3dJPSH
   ekY6xM7/LzSg6dwIEYHx0xuXYSj7+3xFqeR0Q4yIJnDnGDA8E4WmfzVGY
   5gvV1gjS+mt2qPqI+rrHPCYpuUbb+q3uHnEOlWuYAjRAGFCOdH+8wsw/Y
   4MQHYXjv4GSVgiKuRaJLtAZhHxRP3B3OKTis7JCPMYad2z9ieRbLFu5wK
   KrCjdwE//mZgI1cNNzuM4Rj1+oD/6U3uvW2EPcoWG8wDipUXr9cWrL15q
   A==;
X-CSE-ConnectionGUID: bRSL7rOoQc2xRdrzg6sv9Q==
X-CSE-MsgGUID: ABRIqXfiRGurdYQYu5f33w==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="84619149"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="84619149"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 14:38:40 -0700
X-CSE-ConnectionGUID: KJsZjIlWS5mi9PP3v+sLlA==
X-CSE-MsgGUID: O7MFVotpQB6b3MNqNjJKwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="246385948"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.111.27]) ([10.125.111.27])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 14:38:40 -0700
Content-Type: multipart/mixed; boundary="------------0m1d07uIvVYCOsJPGexh30xr"
Message-ID: <eea0497f-6930-43e3-947d-dae139e657ad@intel.com>
Date: Wed, 27 May 2026 14:38:05 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/7] x86/msr: add wrmsrq_on_cpus helper
To: Borislav Petkov <bp@alien8.de>, Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1779133590.git.ashish.kalra@amd.com>
 <c9fe5c2fef063f5006cc9bfa03eec824ac015db7.1779133590.git.ashish.kalra@amd.com>
 <20260527210603.GCahdcu8zvVjfKfGEL@fat_crate.local>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260527210603.GCahdcu8zvVjfKfGEL@fat_crate.local>

This is a multi-part message in MIME format.
--------------0m1d07uIvVYCOsJPGexh30xr
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/27/26 14:06, Borislav Petkov wrote:
> On Mon, May 18, 2026 at 09:42:15PM +0000, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> The existing wrmsr_on_cpus() takes a per-cpu struct msr array, requiring
>> callers to allocate and populate per-cpu storage even when every CPU
>> receives the same value. This is unnecessary overhead for the common
>> case of writing a single uniform u64 to a per-CPU MSR across multiple
>> CPUs.
>>
>> Add wrmsrq_on_cpus() which writes the same u64 value to the specified
>> MSR on all CPUs in the given cpumask.
> 
> So let's add yet another function which name differs from the other one by
> a single letter and have people go look at the implementation to know which is
> which...?
> 
> Instead of unifying what's there and extending this one to do what you want it
> to do?
> 
> And now you have a wrmsrQ_on_cpus() but no rdmsrQ_on_cpus()?
> 
> Because if you look at the code, you'll see how those are used: first you
> rdmsr on CPUs, modify each value and then wrmsr on same CPUs.

This one is my doing.

wrmsr_on_cpus() is kinda a mess. I think it only has a single user. It's
also not very flexible because it needs a 'struct msr __percpu *msrs'
argument where each MSR has a value in memory.

The use case for RMPOPT is that all CPUs get the same value. It'd be a
little awkward to go create a percpu data structure to duplcate the same
value to call wrmsr_on_cpus(). The RMPOPT case is also arguably
performance sensitive since it's done during boot. It should do the IPIs
in parallel.

toggle_ecc_err_reporting(), on the other hand, is done at module init
time. It's not really performance sensitive. It's probably pretty easy
to zap wrmsr_on_cpus() and just have toggle_ecc_err_reporting() do
something slightly less efficient.

Yeah, the

	wrmsr_on_cpus()
	wrmsrq_on_cpus()

naming pain is real. There's little chance of bugs coming from it
because the function signatures are *SO* different. But, it certainly
could confuse humans for a minute.

But the real solution to this is axing wrmsr_on_cpus(). Which I think we
could do after killing its one user which the attached (completely
untested) patch does. The only downside of the patch is that it does
RDMSR via IPIs one CPU at a time. But, looking at the code, I'm not sure
anyone would care. If anyone did, I _think_ all those MSRs have the same
value and the code could be simplified further. But that would take more
than 3 minutes.

It's also possible that my grepping was bad or I'm completely
misunderstanding amd64_edac.c. Cluebat welcome if I'm being dense.

BTW, I also don't feel the need to make Ashish go do any of this edac
cleanup. I think it can just be done in parallel. But I wouldn't stop
him if he volunteered.
--------------0m1d07uIvVYCOsJPGexh30xr
Content-Type: text/x-patch; charset=UTF-8; name="axe-wrmsr_on_cpus.patch"
Content-Disposition: attachment; filename="axe-wrmsr_on_cpus.patch"
Content-Transfer-Encoding: base64

CgotLS0KCiBiL2RyaXZlcnMvZWRhYy9hbWQ2NF9lZGFjLmMgfCAgIDM1ICsrKysrKysrKysr
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9u
cygrKSwgMjQgZGVsZXRpb25zKC0pCgpkaWZmIC1wdU4gZHJpdmVycy9lZGFjL2FtZDY0X2Vk
YWMuY35heGUtd3Jtc3Jfb25fY3B1cyBkcml2ZXJzL2VkYWMvYW1kNjRfZWRhYy5jCi0tLSBh
L2RyaXZlcnMvZWRhYy9hbWQ2NF9lZGFjLmN+YXhlLXdybXNyX29uX2NwdXMJMjAyNi0wNS0y
NyAxNDoyNTowNy44ODE2OTQxNTIgLTA3MDAKKysrIGIvZHJpdmVycy9lZGFjL2FtZDY0X2Vk
YWMuYwkyMDI2LTA1LTI3IDE0OjMzOjAzLjI3ODEzOTgyMSAtMDcwMApAQCAtMTQsOCArMTQs
NiBAQCBzdGF0aWMgc3RydWN0IGVkYWNfcGNpX2N0bF9pbmZvICpwY2lfY3RsCiBzdGF0aWMg
aW50IGVjY19lbmFibGVfb3ZlcnJpZGU7CiBtb2R1bGVfcGFyYW0oZWNjX2VuYWJsZV9vdmVy
cmlkZSwgaW50LCAwNjQ0KTsKIAotc3RhdGljIHN0cnVjdCBtc3IgX19wZXJjcHUgKm1zcnM7
Ci0KIHN0YXRpYyBpbmxpbmUgdTMyIGdldF91bWNfcmVnKHN0cnVjdCBhbWQ2NF9wdnQgKnB2
dCwgdTMyIHJlZykKIHsKIAlpZiAoIXB2dC0+ZmxhZ3Muem5fcmVnc192MikKQEAgLTMyMTUs
MTQgKzMyMTMsMTQgQEAgc3RhdGljIGJvb2wgbmJfbWNlX2JhbmtfZW5hYmxlZF9vbl9ub2Rl
KAogCiAJZ2V0X2NwdXNfb25fdGhpc19kY3RfY3B1bWFzayhtYXNrLCBuaWQpOwogCi0JcmRt
c3Jfb25fY3B1cyhtYXNrLCBNU1JfSUEzMl9NQ0dfQ1RMLCBtc3JzKTsKLQogCWZvcl9lYWNo
X2NwdShjcHUsIG1hc2spIHsKLQkJc3RydWN0IG1zciAqcmVnID0gcGVyX2NwdV9wdHIobXNy
cywgY3B1KTsKLQkJbmJlID0gcmVnLT5sICYgTVNSX01DR0NUTF9OQkU7CisJCXU2NCBtY2df
Y3RsOworCisJCXJkbXNycV9vbl9jcHUoY3B1LCBNU1JfSUEzMl9NQ0dfQ1RMLCAmbWNnX2N0
bCk7CisJCW5iZSA9IG1jZ19jdGwgJiBNU1JfTUNHQ1RMX05CRTsKIAogCQllZGFjX2RiZygw
LCAiY29yZTogJXUsIE1DR19DVEw6IDB4JWxseCwgTkIgTVNSIGlzICVzXG4iLAotCQkJIGNw
dSwgcmVnLT5xLCBzdHJfZW5hYmxlZF9kaXNhYmxlZChuYmUpKTsKKwkJCSBjcHUsIG1jZ19j
dGwsIHN0cl9lbmFibGVkX2Rpc2FibGVkKG5iZSkpOwogCiAJCWlmICghbmJlKQogCQkJZ290
byBvdXQ7CkBAIC0zMjQ2LDI2ICszMjQ0LDI1IEBAIHN0YXRpYyBpbnQgdG9nZ2xlX2VjY19l
cnJfcmVwb3J0aW5nKHN0cnUKIAogCWdldF9jcHVzX29uX3RoaXNfZGN0X2NwdW1hc2soY21h
c2ssIG5pZCk7CiAKLQlyZG1zcl9vbl9jcHVzKGNtYXNrLCBNU1JfSUEzMl9NQ0dfQ1RMLCBt
c3JzKTsKLQogCWZvcl9lYWNoX2NwdShjcHUsIGNtYXNrKSB7CisJCXU2NCBtY2dfY3RsOwog
Ci0JCXN0cnVjdCBtc3IgKnJlZyA9IHBlcl9jcHVfcHRyKG1zcnMsIGNwdSk7CisJCXJkbXNy
cV9vbl9jcHUoY3B1LCBNU1JfSUEzMl9NQ0dfQ1RMLCAmbWNnX2N0bCk7CiAKIAkJaWYgKG9u
KSB7Ci0JCQlpZiAocmVnLT5sICYgTVNSX01DR0NUTF9OQkUpCisJCQlpZiAobWNnX2N0bCAm
IE1TUl9NQ0dDVExfTkJFKQogCQkJCXMtPmZsYWdzLm5iX21jZV9lbmFibGUgPSAxOwogCi0J
CQlyZWctPmwgfD0gTVNSX01DR0NUTF9OQkU7CisJCQltY2dfY3RsIHw9IE1TUl9NQ0dDVExf
TkJFOwogCQl9IGVsc2UgewogCQkJLyoKIAkJCSAqIFR1cm4gb2ZmIE5CIE1DRSByZXBvcnRp
bmcgb25seSB3aGVuIGl0IHdhcyBvZmYgYmVmb3JlCiAJCQkgKi8KIAkJCWlmICghcy0+Zmxh
Z3MubmJfbWNlX2VuYWJsZSkKLQkJCQlyZWctPmwgJj0gfk1TUl9NQ0dDVExfTkJFOworCQkJ
CW1jZ19jdGwgJj0gfk1TUl9NQ0dDVExfTkJFOwogCQl9CisJCXdybXNycV9vbl9jcHUoY3B1
LCBNU1JfSUEzMl9NQ0dfQ1RMLCBtY2dfY3RsKTsKIAl9Ci0Jd3Jtc3Jfb25fY3B1cyhjbWFz
aywgTVNSX0lBMzJfTUNHX0NUTCwgbXNycyk7CiAKIAlmcmVlX2NwdW1hc2tfdmFyKGNtYXNr
KTsKIApAQCAtNDE1MywxMCArNDE1MCw2IEBAIHN0YXRpYyBpbnQgX19pbml0IGFtZDY0X2Vk
YWNfaW5pdCh2b2lkKQogCWlmICghZWNjX3N0bmdzKQogCQlnb3RvIGVycl9mcmVlOwogCi0J
bXNycyA9IG1zcnNfYWxsb2MoKTsKLQlpZiAoIW1zcnMpCi0JCWdvdG8gZXJyX2ZyZWU7Ci0K
IAlmb3IgKGkgPSAwOyBpIDwgYW1kX25iX251bSgpOyBpKyspIHsKIAkJZXJyID0gcHJvYmVf
b25lX2luc3RhbmNlKGkpOwogCQlpZiAoZXJyKSB7CkBAIC00MTkwLDkgKzQxODMsNiBAQCBz
dGF0aWMgaW50IF9faW5pdCBhbWQ2NF9lZGFjX2luaXQodm9pZCkKIGVycl9wY2k6CiAJcGNp
X2N0bF9kZXYgPSBOVUxMOwogCi0JbXNyc19mcmVlKG1zcnMpOwotCW1zcnMgPSBOVUxMOwot
CiBlcnJfZnJlZToKIAlrZnJlZShlY2Nfc3RuZ3MpOwogCWVjY19zdG5ncyA9IE5VTEw7CkBA
IC00MjIwLDkgKzQyMTAsNiBAQCBzdGF0aWMgdm9pZCBfX2V4aXQgYW1kNjRfZWRhY19leGl0
KHZvaWQpCiAJZWNjX3N0bmdzID0gTlVMTDsKIAogCXBjaV9jdGxfZGV2ID0gTlVMTDsKLQot
CW1zcnNfZnJlZShtc3JzKTsKLQltc3JzID0gTlVMTDsKIH0KIAogbW9kdWxlX2luaXQoYW1k
NjRfZWRhY19pbml0KTsKXwo=

--------------0m1d07uIvVYCOsJPGexh30xr--
