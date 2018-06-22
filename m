From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH 1/2] hwrng: msm: add a spinlock and support for blocking
 reads
Date: Fri, 22 Jun 2018 16:17:24 -0500
Message-ID: <2ad6d37c-66eb-c173-95bc-f838d03e6741@codeaurora.org>
References: <1529594276-12210-1-git-send-email-timur@codeaurora.org>
 <acc7e9d3-8a81-ff15-27c7-78ec7c17f6cc@linaro.org>
 <6d655b97-418e-bacf-7e88-b9179cdc6fd1@codeaurora.org>
 <152968991381.16708.522979730327886581@swboyd.mtv.corp.google.com>
 <4bc0afe1-0189-88c0-40aa-23a312325635@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
To: Stephen Boyd <swboyd@chromium.org>, Matt Mackall <mpm@selenic.com>,
 Stanimir Varbanov <stanimir.varbanov@linaro.org>,
 linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
 linux-crypto@vger.kernel.org, timur@kernel.org, vinod.koul@linaro.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <4bc0afe1-0189-88c0-40aa-23a312325635@codeaurora.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

T24gMDYvMjIvMjAxOCAwMTowMyBQTSwgVGltdXIgVGFiaSB3cm90ZToKPiAKPj4gUGVyaGFwcyBp
dCdzIGJlY2F1c2UgeW91IGltcGxlbWVudGVkIHRoZSAnd2FpdCcgZnVuY3Rpb25hbGl0eSBpbiB0
aGlzCj4+IGRyaXZlcj8gQmVmb3JlIHRoZSBwYXRjaCB0aGVyZSB3YXNuJ3QgYW55IHNvcnQgb2Yg
d2FpdCBjaGVjayBzbyB3ZSB3b3VsZAo+PiBiYWlsIG91dCBpZiB0aGVyZSB3YXNuJ3QgYW55IGRh
dGEgZXZlbiBpZiB0aGUgY2FsbGVyIHJlcXVlc3RlZCB0aGF0IHdlCj4+IHdhaXQgZm9yIHJhbmRv
bW5lc3MgdG8gYmUgYXZhaWxhYmxlLgo+IAo+IE5vLCBteSB0ZXN0cyBzaG93ZWQgdGhlIHJhY2Ug
Y29uZGl0aW9uIChvciBhdCBsZWFzdCBzb21ldGhpbmcgdGhhdCBsb29rcyAKPiBsaWtlIGEgcmFj
ZSBjb25kaXRpb24pIGV2ZW4gd2l0aG91dCB0aGUgJ3dhaXQnIGZlYXR1cmUuwqAgSSBhZGRlZCBz
dXBwb3J0IAo+IGZvciAnd2FpdCcgb25seSByZWNlbnRseSwgYnV0IEkndmUgYmVlbiB3b3JraW5n
IHdpdGggdGhlIGNyeXB0byBwZW9wbGUgCj4gZm9yIGEgbW9udGggb24gZXZlcnl0aGluZyBlbHNl
LgoKTG9va3MgbGlrZSBJIHdhcyB3cm9uZy4KCkkgY3JlYXRlZCBzb21lIG5ldyB0ZXN0cyB0byBy
ZXByb2R1Y2UgdGhlIHByb2JsZW0sIGJ1dCBJIGNhbid0IHJlcHJvZHVjZSAKaXQgYW55IG1vcmUu
ICBJIGNhbiBvbmx5IGFzc3VtZSB0aGF0IHdoYXQgSSBzYXcgYXMgYSByYWNlIGNvbmRpdGlvbiBi
YWNrIAp0aGVuIHdhcyBzb21ldGhpbmcgZWxzZSBlbnRpcmVseS4KClNvIGFsbCBvZiB0aGUgc3Bp
bmxvY2sgY29kZSBuZWVkcyB0byBnby4gIEl0IGxvb2tzIGxpa2UgYXQgdGhpcyBwb2ludCwgCmlm
IFZpbm9kIGNhbiBhZGQgc3VwcG9ydCBmb3IgUUNPTTgxNjAgdG8gaGlzIHBhdGNoZXMsIHRoZSBv
bmx5IHRoaW5nIEkgCmNhbiBjb250cmlidXRlIGlzIHN1cHBvcnQgZm9yICd3YWl0Jy4KCi0tIApR
dWFsY29tbSBEYXRhY2VudGVyIFRlY2hub2xvZ2llcywgSW5jLiBhcyBhbiBhZmZpbGlhdGUgb2Yg
UXVhbGNvbW0KVGVjaG5vbG9naWVzLCBJbmMuICBRdWFsY29tbSBUZWNobm9sb2dpZXMsIEluYy4g
aXMgYSBtZW1iZXIgb2YgdGhlCkNvZGUgQXVyb3JhIEZvcnVtLCBhIExpbnV4IEZvdW5kYXRpb24g
Q29sbGFib3JhdGl2ZSBQcm9qZWN0LgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KbGludXgtYXJtLWtlcm5lbCBtYWlsaW5nIGxpc3QKbGludXgtYXJtLWtl
cm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnCmh0dHA6Ly9saXN0cy5pbmZyYWRlYWQub3JnL21haWxt
YW4vbGlzdGluZm8vbGludXgtYXJtLWtlcm5lbAo=
