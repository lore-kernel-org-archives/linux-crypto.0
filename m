From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 00/18] Fix some build warnings/errors with Sphinx
Date: Tue, 8 May 2018 10:13:42 -0600
Message-ID: <20180508101342.2bde20ea@lwn.net>
References: <cover.1525684985.git.mchehab+samsung@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-fbdev@vger.kernel.org,
 Linux Doc Mailing List <linux-doc@vger.kernel.org>, linux-iio@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
 "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-mtd@lists.infradead.org,
 linux-crypto@vger.kernel.org, linux-can@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <cover.1525684985.git.mchehab+samsung@kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
List-Id: linux-crypto.vger.kernel.org

T24gTW9uLCAgNyBNYXkgMjAxOCAwNjozNTozNiAtMDMwMApNYXVybyBDYXJ2YWxobyBDaGVoYWIg
PG1jaGVoYWIrc2Ftc3VuZ0BrZXJuZWwub3JnPiB3cm90ZToKCj4gSSBkZWNpZGVkIHRvIGdpdmUg
YSB0cnkgd2l0aCBTcGhpbnggbGFzdCBzdGFibGUgdmVyc2lvbgo+ICgxLjE3LjQpLCBhbmQgbm90
aWNlZCBzZXZlcmFsIGlzc3Vlcy4gVGhlIHdvcnNlIG9uZSB3YXMKPiB3aXRoIHRoZSBuZXR3b3Jr
aW5nIGJvb2s6IGEgbm9uLXN0YW5kYXJkIGZvb3Rub3RlIHRoZXJlCj4gd2l0aCBbKl0gaW5zdGVh
ZCBvZiBhIG51bWJlciBjYXVzZXMgaXQgdG8gYnJlYWsgUERGIGJ1aWxkaW5nLgo+IAo+IFNvLCBJ
IHRvb2sgc29tZSBzcGFyZSB0aW1lIHRvIGFkZHJlc3Mgc29tZSB3YXJuaW5ncyBhbGwgb3Zlcgo+
IHRoZSB0cmVlLCBhbmQgbW92ZWQgYSBmZXcgdGV4dCBkb2N1bWVudHMgdG8gYSBib29rLiAKCk9L
LCBJJ3ZlIGFwcGxpZWQgdGhlIG9uZXMgdGhhdCBzZWVtIHRvIG1ha2Ugc2Vuc2UgZm9yIG1lIHRv
IHRha2Ugbm93LgpUaGVyZSdzIGNvbW1lbnRzIG9uIHRoZSBmaXJtd2FyZSBvbmUsIGFuZCBJJ2Qg
cmF0aGVyIGhhdmUgVGVqdW4ncyBPSyBmb3IKdGhlIGNncm91cCBvbmUuICBUaGUgY29kZS1jb21t
ZW50IGNoYW5nZXMgc2hvdWxkIHByb2JhYmx5IGdvIHZpYSB0aGUKdXN1YWwgbWFpbnRhaW5lcnMu
Cgo+IEkgd2l0aAo+IEkgaGFkIG1vcmUgdGltZSB0byBtb3ZlIHRoZSBvdGhlciBvbmVzIGFuZCB0
byBzb2x2ZSBvdGhlcgo+IHdhcm5pbmdzLgoKWW91IGFuZCBtZSBib3RoIC0gYnV0IGVhY2ggc3Rl
cCBoZWxwcyEKClRoYW5rcywKCmpvbgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVl
ZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5m
by9kcmktZGV2ZWwK
