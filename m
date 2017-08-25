From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: x86: PIE support and option to extend KASLR
	randomization
Date: Thu, 24 Aug 2017 21:07:00 -0400
Message-ID: <20170824210700.5fd3b5a0@gandalf.local.home>
References: <20170810172615.51965-1-thgarnie@google.com>
 <20170811124127.kkb5pnkljz4umxuj@gmail.com>
 <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
 <20170815075609.mmzbfwritjzvrpsn@gmail.com>
 <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com>
 <CAJcbSZFM_zpL1av1JVaow8NdsGeH+6oZKeDnMPdXR0PGfynzsg@mail.gmail.com>
 <20170817080920.5ljlkktngw2cisfg@gmail.com>
 <CAJcbSZGbtc-i0X1NiBAvZA7cxpGkwSLKNB7oDNCsFxOCdhkR_g@mail.gmail.com>
 <CAJcbSZGhvwt=5ERtBHLJnwS=6AXBZLTMfrafzeUCqYy=-MKWDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
 Peter Zijlstra <a.p.zijlstra@chello.nl>, Michal Hocko <mhocko@suse.com>,
 kvm list <kvm@vger.kernel.org>,
 Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Christopher Li <sparse@chrisli.org>,
 Alexei Starovoitov <ast@kernel.org>, David Howells <dhowells@redhat.com>,
 Paul Gortmaker <paul.gortmaker@windriver.com>, Pavel Machek <pavel@ucw.cz>,
 "H . Peter Anvin" <hpa@zytor.com>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Christoph Lameter <cl@linux.com>, Ingo Molnar <mingo@kernel.org>,
 Kees Cook <keescook@chromium.org>, the arch/x86
 maintainers <x86@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Matthew Wilcox <mawilcox@microsoft.com>, Peter Foley <pefoley2@pefoley.com>,
 Joerg Roedel <joro
To: Thomas Garnier <thgarnie@google.com>
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <CAJcbSZGhvwt=5ERtBHLJnwS=6AXBZLTMfrafzeUCqYy=-MKWDg@mail.gmail.com>
List-Unsubscribe: <https://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <https://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xen.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xen.org>
List-Id: linux-crypto.vger.kernel.org

T24gVGh1LCAyNCBBdWcgMjAxNyAxNDoxMzozOCAtMDcwMApUaG9tYXMgR2FybmllciA8dGhnYXJu
aWVAZ29vZ2xlLmNvbT4gd3JvdGU6Cgo+IFdpdGggdGhlIGZpeCBmb3IgZnVuY3Rpb24gdHJhY2lu
ZywgdGhlIGhhY2tiZW5jaCByZXN1bHRzIGhhdmUgYW4KPiBhdmVyYWdlIG9mICswLjggdG8gKzEu
NCUgKGZyb20gKzglIHRvICsxMCUgYmVmb3JlKS4gV2l0aCBhIGRlZmF1bHQKPiBjb25maWd1cmF0
aW9uLCB0aGUgbnVtYmVycyBhcmUgY2xvc2VyIHRvIDAuOCUuCgpXb3csIGFuIGVtcHR5IGZlbnRy
eSBmdW5jdGlvbiBub3QgIm5vcCJlZCBvdXQgb25seSBhZGRlZCA4JSB0byAxMCUKb3ZlcmhlYWQu
IEkgbmV2ZXIgZGlkIHRoZSBiZW5jaG1hcmtzIG9mIHRoYXQgc2luY2UgSSBkaWQgaXQgYmVmb3Jl
CmZlbnRyeSB3YXMgaW50cm9kdWNlZCwgd2hpY2ggd2FzIHdpdGggdGhlIG9sZCAibWNvdW50Ii4g
VGhhdCBnYXZlIGFuCmF2ZXJhZ2Ugb2YgMTMlIG92ZXJoZWFkIGluIGhhY2tiZW5jaC4KCi0tIFN0
ZXZlCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpYZW4t
ZGV2ZWwgbWFpbGluZyBsaXN0Clhlbi1kZXZlbEBsaXN0cy54ZW4ub3JnCmh0dHBzOi8vbGlzdHMu
eGVuLm9yZy94ZW4tZGV2ZWwK
